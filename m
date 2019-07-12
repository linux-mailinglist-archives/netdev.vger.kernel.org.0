Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC6E662D4
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbfGLA2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:28:14 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39744 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfGLA2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:28:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so8083018wrt.6;
        Thu, 11 Jul 2019 17:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e/jWg+zjIBv5+p5y9f7E+7Bbbd4STuPUddNzmbi3FZE=;
        b=aiWoPWk3zorUBWgYbgtltG1czQEyfkv8HWSMRcf6ri6fcEVtnQtAehmEKAlFDf7V/z
         KF8lGw0M1NXYI0ddmTnIKDLAvx7P+joj7s7RgOoMNDDVKDNkMoF0kip7Lzt6+t3QCnL1
         J05fCSg6Ysw/6jNQns0eJMxK1tI7NxiPvyGhGlqmZe1wwFdUcyHShdR8VjMzcG2nep8G
         Q5hl55K0KYBteAYzMpspuiW1CbzY7oJ7p9GBIiWfsh4rhxBW6H+8jfJ1pm4OUF+in69S
         RXBezz86juqtGdWqGuO8eSdn8edDIOOSoMyXvA8+sCxfWnPtwNk4qyLoewJCEsqwHaPJ
         6fZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e/jWg+zjIBv5+p5y9f7E+7Bbbd4STuPUddNzmbi3FZE=;
        b=e7y1dCe2vfnztiEFY8Uk2LA7rXMKBksRMtV/wyHMQSE9TE9/jAAcnm3gVYTTKPg5iK
         LuJMhXR0k0qyYJj4dBeoFtZ0PDJStyBw4fZekMULU9MRfcm7eyHOpmBEPyvUc0H+Pm04
         +YuVFVpWD+cTSEmwL8CIRrzDozvknJkbPKla8KL5Vu/EnR6OYkde9n13UWA7E5Ouj2O+
         xy33xgpfrOUEKwVQo7RgYLtDI/CU9/WEGxUGG3Lxspv79Z3gavbtNsTe33JAGkSL1wfE
         13owm0WU1KByAiNjoDaproTranteAr4iVb/cZ6NAFnlURQ29j6UO93CpY6p7t3lpLKtO
         jeKg==
X-Gm-Message-State: APjAAAUwFtLIZdUJPMV2hDsX68H8H9GGTtj0NFLeizpxsGlK/C2yWayu
        MHgitb7ngavGKTlMVzP/OiY=
X-Google-Smtp-Source: APXvYqx+1vdp5t+0cDVLEH9+0K1fqF2L+h3jTSf0fNGdkufZmGyetM35geKNjyQFjjL7ZqH/aQD6Lw==
X-Received: by 2002:adf:dbcb:: with SMTP id e11mr7194355wrj.272.1562891292358;
        Thu, 11 Jul 2019 17:28:12 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id 15sm4659228wmk.34.2019.07.11.17.28.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 17:28:11 -0700 (PDT)
Date:   Thu, 11 Jul 2019 17:28:09 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     kvalo@codeaurora.org, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
Message-ID: <20190712002809.GA7746@archlinux-threadripper>
References: <20190712001708.170259-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712001708.170259-1-ndesaulniers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 05:17:06PM -0700, Nick Desaulniers wrote:
> Commit r353569 in prerelease Clang-9 is producing a linkage failure:
> 
> ld: drivers/net/wireless/intel/iwlwifi/fw/dbg.o:
> in function `_iwl_fw_dbg_apply_point':
> dbg.c:(.text+0x827a): undefined reference to `__compiletime_assert_2387'
> 
> when the following configs are enabled:
> - CONFIG_IWLWIFI
> - CONFIG_IWLMVM
> - CONFIG_KASAN
> 
> Work around the issue for now by marking the debug strings as `static`,
> which they probably should be any ways.
> 
> Link: https://bugs.llvm.org/show_bug.cgi?id=42580
> Link: https://github.com/ClangBuiltLinux/linux/issues/580
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Applied on next-20190711 and I can confirm that this fixes the issue we
observed. Thanks to you for wrapping up the patch and sending it and to
Eli for giving the suggestion.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
