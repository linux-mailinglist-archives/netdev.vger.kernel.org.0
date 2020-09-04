Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E0525E16D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 20:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgIDSUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 14:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgIDSUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 14:20:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBED4C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 11:20:12 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so4746814pgl.2
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 11:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZaTrUuA2BY8VTDbhZYB/PnTTEh9v5LaOuKHppH01V84=;
        b=qXYOaXk1OuRH1t2e70Zyd6hVeER3dBLJB8FkvqulNrZ7DWuf/+2exwy8TUFR77LhCC
         q5f+VPzV6B7jJSK3nwyZmv3DzfTM0xXHoRyAwjOAiIxkF2jsGG5i2YDl5U7C9stYJB6v
         MYljE5tC9bAONTzuk58cLdPeu9/5sMAD0+KRdRudlJuD7XB35+OFe1/9Re+b5QMuFJu7
         w2ORjmvNZNkChMqKkX8h3h5xIRTYhtvBfC6THb2X4fwJZcKhKiOMO67+jb3vOPZXM8su
         FxMewzBCAusqLYf5LB6BjXh9R9Bwz0t7rivbOEvd8rc4WmTPlfLOqYkv/3V4oHoCiR4T
         DLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZaTrUuA2BY8VTDbhZYB/PnTTEh9v5LaOuKHppH01V84=;
        b=LKpXBofnAbrHnxGzM/KDfLBlsa/sXXMHYF7bOU9vOXtBsnNrGoUISaHJWGF37w+fTN
         oszSApwbP7vsUuh7+uTk0Kvilh0hYUFREMBIWQFETIrjIzXqonXj96CRd02SPUtsXYXB
         3ofuz1rVVTS0vzQntNuFEIsb7P/l5mczA0cA0oF1oMYlhU1L9SFAnV1lVltuEh/+RxJT
         wkxdsy1Zsf8///B6Lz7vi9ovGQcCbRY0WsZWxW+Ahlo66bVF8hkvrGlspyH2z+2BPdpJ
         IY1jJl2BfVhxljU5cKPgY6XPzQh9l33iRE0abn0K6HN+3WC9WKv9eE0m+Qabc+O6uQP6
         sBlg==
X-Gm-Message-State: AOAM533JUrhx+m2G39Bat3+zkL0jwjrrpIu++HcWIua0MB1QI86r5TyZ
        TH/1pG7qH1iS4hDAmZDN8g+Bgw==
X-Google-Smtp-Source: ABdhPJzYuu3LNXA/TNYffF4vUNgU9HhYCLeO6Nh79fHhnhSronTn6Y2OeifVbufFKhhCks8OsMfUbQ==
X-Received: by 2002:a63:9041:: with SMTP id a62mr7959140pge.273.1599243612408;
        Fri, 04 Sep 2020 11:20:12 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 8sm6114595pjx.14.2020.09.04.11.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 11:20:11 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 0/2] ionic: add devlink dev flash support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200904000534.58052-1-snelson@pensando.io>
 <20200904080130.53a66f32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <f6c0abae-a5ca-2bbb-35da-5b5480c1ebe7@pensando.io>
Date:   Fri, 4 Sep 2020 11:20:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200904080130.53a66f32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 8:01 AM, Jakub Kicinski wrote:
> On Thu,  3 Sep 2020 17:05:32 -0700 Shannon Nelson wrote:
>> Add support for using devlink's dev flash facility to update the
>> firmware on an ionic device.  This is a simple model of pushing the
>> firmware file to the NIC, asking the NIC to unpack and install the file
>> into the device, and then selecting it for the next boot.  If any of
>> these steps fail, the whole transaction is failed.
>>
>> We don't currently support doing these steps individually.  In the future
>> we want to be able to list the FW that is installed and selectable but
>> don't yet have the API to fully support that.
>>
>> v2: change "Activate" to "Select" in status messages
> Thanks!
>
> Slightly off-topic for these patches but every new C file in ionic adds
> a set of those warnings (from sparse, I think, because it still builds):
>
> ../drivers/net/ethernet/pensando/ionic/ionic_debugfs.c: note: in included file (through ../drivers/net/ethernet/pensando/ionic/ionic.h):
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:37:1: error: static assertion failed: "sizeof(union ionic_dev_regs) == 4096"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:39:1: error: static assertion failed: "sizeof(union ionic_dev_cmd_regs) == 2048"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:55:1: error: static assertion failed: "sizeof(struct ionic_dev_getattr_comp) == 16"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:56:1: error: static assertion failed: "sizeof(struct ionic_dev_setattr_cmd) == 64"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:57:1: error: static assertion failed: "sizeof(struct ionic_dev_setattr_comp) == 16"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:67:1: error: static assertion failed: "sizeof(struct ionic_port_getattr_comp) == 16"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:77:1: error: static assertion failed: "sizeof(struct ionic_lif_getattr_comp) == 16"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:78:1: error: static assertion failed: "sizeof(struct ionic_lif_setattr_cmd) == 64"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:79:1: error: static assertion failed: "sizeof(struct ionic_lif_setattr_comp) == 16"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:81:1: error: static assertion failed: "sizeof(struct ionic_q_init_cmd) == 64"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:118:1: error: static assertion failed: "sizeof(struct ionic_vf_setattr_cmd) == 64"
> ../drivers/net/ethernet/pensando/ionic/ionic_dev.h:121:1: error: static assertion failed: "sizeof(struct ionic_vf_getattr_comp) == 16"
>
> Any ideas on why?

It's probably related to this discussion:
https://lore.kernel.org/linux-sparse/ecdd10cb-0022-8f8a-ec36-9d51b3ae85ee@pensando.io/

I thought we'd worked out our struct alignment issues, but I'll see if I 
can carve out some time to take another look at that.

sln

