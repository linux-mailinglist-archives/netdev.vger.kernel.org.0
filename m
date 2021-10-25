Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0882243933F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhJYKB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhJYKBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 06:01:53 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8349C061745;
        Mon, 25 Oct 2021 02:59:30 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id q16so8229807ljg.3;
        Mon, 25 Oct 2021 02:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+TIj5y8QsMaTWrj/bXk+5lqEByFxDn6ZBGaeeKVM1t4=;
        b=gmHqC4hXEi/uZzQY9R3wXUpk8h9YSkzbPgGyvI3qxU923udgW1KbfxMv1NdrplM5hl
         P7KAA6WxIimu2DyeqQCxdo4jUKFwLATk3mOgXJh3BI66u6wbXZw7oN0lroexTTbdg1Ov
         NUs817d0u5leYI7bCHlEDmPjxHJR3pNk3fp8SLEirwNbmHpeIsuZuAJ/+X2jIPQG8WPp
         U5SqGQeBWn8eeTzxCaVMx0+BKIkStLLaaEDh73d4NgiwYJpfcQCA7BZ3fV1CGir9zx87
         +Mhkp8TrR0B4ZHLqEqvCul1fa6HPXMJ0RwIu8NuNQJwcZ7yV8/Yqj5pkXeLX0zaZcovD
         mUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+TIj5y8QsMaTWrj/bXk+5lqEByFxDn6ZBGaeeKVM1t4=;
        b=lzFiOax7ZZKPGtsLFyrJvn0wrzfIGBmjOUjR1OP6TfL5a4TIJqEndj0GJN+3+K0gyI
         oJLonGV54bWTRqRJl2wu1Nh+WfiXNCHPYtx+i9Y8OA6OqxHOe6twxNSG8SXBF4lM5975
         doXWaZOFLM796MIMcl+xd1cQxOGsy/Jhfxr1rjBqsiue17J5gs/M8S7rwJbl0uagrVpO
         pjf08SN0T1GvKup3QHtn5iVleJhxcx83ZQvhAHlB9e22DDTWNjo2O7x2MYExW45/dwcy
         0lEt2D8g+JN3XGuN1Oi1j4xduwowbW3p7GhBJ2xMyFTnu+mRSgJWN2Wz1P+lnA/Z+Oq2
         0wfA==
X-Gm-Message-State: AOAM532I+MQ87NspxfQtge4thLnGqydLT65B8XcL50zBcbJl80KgTj0e
        guXRNaWE/+tAXZC1wu0unNU=
X-Google-Smtp-Source: ABdhPJwehqJNnfIOxj7asWNT4mHVfIICRvlh5rfggFDthwIhGRiIVTpHn+T8Kld3zmZQ6HMr9pe3LA==
X-Received: by 2002:a05:651c:554:: with SMTP id q20mr17890375ljp.118.1635155969220;
        Mon, 25 Oct 2021 02:59:29 -0700 (PDT)
Received: from kari-VirtualBox (85-23-89-224.bb.dnainternet.fi. [85.23.89.224])
        by smtp.gmail.com with ESMTPSA id b16sm1534228lfb.220.2021.10.25.02.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 02:59:28 -0700 (PDT)
Date:   Mon, 25 Oct 2021 12:59:27 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH v20 2/2] wireless: Initial driver submission for pureLiFi
 STA devices
Message-ID: <20211025095927.cssdlblcdprdwfsy@kari-VirtualBox>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20211018100143.7565-1-srini.raju@purelifi.com>
 <20211018100143.7565-3-srini.raju@purelifi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018100143.7565-3-srini.raju@purelifi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:00:55AM +0100, Srinivasan Raju wrote:
> This driver implementation has been based on the zd1211rw driver
> 
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management
> 
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture

I have run some static analyzing tools against this driver. Here is my
findings. If you have CI system in house I strongly recommend that you
take these in use. Note that I have included just what might be real
warnings but they might also not be. Please check them.

------------------------------------------
Thease are just what I found myself.

drivers/net/wireless/purelifi/plfxlc/usb.c:47:
Has static. Will not work with multiple device.

drivers/net/wireless/purelifi/plfxlc/mac.h:75: You use spaces over tabs.
drivers/net/wireless/purelifi/plfxlc/mac.c:704: You use spaces over tabs.
drivers/net/wireless/purelifi/plfxlc/usb.c:920: You use spaces over tabs.
There is more of these. Please find all of them.

------------------------------------------
$ cppcheck drivers/net/wireless/purelifi/plfxlc/*.[ch] --enable=all

drivers/net/wireless/purelifi/plfxlc/usb.c:55:31: style:
Boolean result is used in bitwise operation. Clarify expression with
parentheses. [clarifyCondition]

drivers/net/wireless/purelifi/plfxlc/mac.c:447:6: style:
Condition '!bad_frame' is always true [knownConditionTrueFalse]

drivers/net/wireless/purelifi/plfxlc/mac.c:572:16: style:
Variable 'changed_flags' is assigned a value that is never used.
[unreadVariable]
        Please check next comment line 577. There you talk about use of
        changed_flags but you never use it.

Unused functions. I do not have opinion if you should remove these or
not, but some times there is bug if some function is unused. Please at
least comment if these are not mistakes.

drivers/net/wireless/purelifi/plfxlc/usb.c:38:0: style: The function 'get_bcd_device' is never used. [unusedFunction]
drivers/net/wireless/purelifi/plfxlc/usb.c:398:0: style: The function 'purelifi_usb_tx' is never used. [unusedFunction]
drivers/net/wireless/purelifi/plfxlc/chip.h:64:0: style: The function 'purelifi_mc_clear' is never used. [unusedFunction]
drivers/net/wireless/purelifi/plfxlc/chip.c:75:0: style: The function 'purelifi_chip_disable_rxtx' is never used. [unusedFunction]
drivers/net/wireless/purelifi/plfxlc/chip.h:79:0: style: The function 'purelifi_mc_add_addr' is never used. [unusedFunction]
drivers/net/wireless/purelifi/plfxlc/mac.c:89:0: style: The function 'purelifi_mac_init_hw' is never used. [unusedFunction]

------------------------------------------
$ codespell drivers/net/wireless/purelifi/plfxlc/*.[ch]

mac.c:237: ocasions ==> occasions
------------------------------------------
$ ./scripts/checkpatch.pl --strict drivers/net/wireless/purelifi/plfxlc/*.[ch]
$ make coccicheck M=drivers/net/wireless/purelifi/plfxlc/
$ flawfinder drivers/net/wireless/purelifi/plfxlc/*.[ch]

$ touch drivers/net/wireless/purelifi/plfxlc/*.[ch]
$ make -j6 W=1

These were all good.
------------------------------------------
$ touch drivers/net/wireless/purelifi/plfxlc/*.[ch]
$ make -j6 CC=clang W=1 drivers/net/wireless/purelifi/plfxlc/

drivers/net/wireless/purelifi/plfxlc/usb.c:38:19: warning:
unused function 'get_bcd_device' [-Wunused-function]

drivers/net/wireless/purelifi/plfxlc/usb.c:55:7: warning:
logical not is only applied to the left hand side of this bitwise
operator [-Wlogical-not-parentheses]
------------------------------------------
$ ~/smatch/smatch_scripts/build_kernel_data.sh
$ ~/smatch/smatch_scripts/kchecker drivers/net/wireless/purelifi/plfxlc/

drivers/net/wireless/purelifi/plfxlc/usb.c:55
purelifi_send_packet_from_data_queue() warn: add some parenthesis here?

drivers/net/wireless/purelifi/plfxlc/mac.c:685
purelifi_get_et_strings() error: memcpy() '*et_strings' too small (32 vs 64)

  Argillander
