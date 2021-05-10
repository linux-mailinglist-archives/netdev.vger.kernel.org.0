Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126C6378F41
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhEJNnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbhEJNR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 09:17:26 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3A6C06138C;
        Mon, 10 May 2021 06:16:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so8868251wmb.3;
        Mon, 10 May 2021 06:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sh4i9feljTPFrIfpR/IU/E8n0D3Fda88xyQfypmum7w=;
        b=GfQpYA/u/ESXNzCwhJN35I1L0Sb2vRVeukRNG83W8xG2OMlDA6+i5W0OODo/+LWE9E
         ivWW5//Dci3M+PXPgJnH/odM7KtTO7yjQKrEe7KAvh4E7fvrd/ZuLkJAZP62sWtsDMuB
         AIqgCRqoTLZzj0iGC6/REa3QuGlmZjiRxifV0mZYrMLJSap8JjiujnvbMmFTzTlx+O95
         x9XnwiLNDr5qqWcsdoyW+ETG1hWAlzA+FW12aKJEwh2j5DlnppfpjkE6ahf9DAyZ8V+v
         c4HLN0tsaWZM2+zfMzrOFU3u/mXI98pyg6LlDYSgFBtDuHlk1DmX0lhge4HX1KOLhtwA
         z+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sh4i9feljTPFrIfpR/IU/E8n0D3Fda88xyQfypmum7w=;
        b=cYGoVbnuzC8qi/rSzJ+ExaPcPY6WDiRnoQYrUOJUW/LDLaupeK70YlIz31CC6DpEIO
         YjQqqXw2K1KRvLE2EmkMqZgmSNaOqjLw3WgaQER7nKYN78smSnUQvql/Lq9C3BYIAbbS
         A89hiMUo84LxHpIIH5PXWbH2rmZnREpJ+CAq/H0QPEPvY3481ifRRLSpOK8Cv3AHyzwB
         Y9C4Y5kQCgYC6MsNt9LSL+mATP7JJWBNR9KZjed7REYhOTmkJTYOrQnd1aSrwgzazjvo
         Ixtv6yd4OPdU4nF7WYCxOtY9Watsai28mxpDWeEFK5xhy198jgxuKAvRFJqigderRiYZ
         zU/w==
X-Gm-Message-State: AOAM5320WfRdSTq1VXESkXjcB7G2WrDl9rtLEDxZcnwiFr7WOtK+XUaU
        ikYqT3CuD1N4pbhEXWdxDhI=
X-Google-Smtp-Source: ABdhPJysoQ4YBpE1J87NsTC/Z24p8NQqGLKPSudpVCmtLwZFhM2Wy0R7/k0aKiXMKdpTI23nPdYVEw==
X-Received: by 2002:a05:600c:47d7:: with SMTP id l23mr36980376wmo.95.1620652578722;
        Mon, 10 May 2021 06:16:18 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id s1sm27945073wmj.8.2021.05.10.06.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 06:16:17 -0700 (PDT)
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as ASCII
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
 <2ae366fdff4bd5910a2270823e8da70521c859af.camel@infradead.org>
 <20210510135518.305cc03d@coco.lan>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <df6b4567-030c-a480-c5a6-fe579830e8c0@gmail.com>
Date:   Mon, 10 May 2021 14:16:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210510135518.305cc03d@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2021 12:55, Mauro Carvalho Chehab wrote:
> The main point on this series is to replace just the occurrences
> where ASCII represents the symbol equally well

> 	- U+2014 ('—'): EM DASH
Em dash is not the same thing as hyphen-minus, and the latter does not
 serve 'equally well'.  People use em dashes because — even in
 monospace fonts — they make text easier to read and comprehend, when
 used correctly.
I accept that some of the other distinctions — like en dashes — are
 needlessly pedantic (though I don't doubt there is someone out there
 who will gladly defend them with the same fervour with which I argue
 for the em dash) and I wouldn't take the trouble to use them myself;
 but I think there is a reasonable assumption that when someone goes
 to the effort of using a Unicode punctuation mark that is semantic
 (rather than merely typographical), they probably had a reason for
 doing so.

> 	- U+2018 ('‘'): LEFT SINGLE QUOTATION MARK
> 	- U+2019 ('’'): RIGHT SINGLE QUOTATION MARK
> 	- U+201c ('“'): LEFT DOUBLE QUOTATION MARK
> 	- U+201d ('”'): RIGHT DOUBLE QUOTATION MARK
(These are purely typographic, I have no problem with dumping them.)

> 	- U+00d7 ('×'): MULTIPLICATION SIGN
Presumably this is appearing in mathematical formulae, in which case
 changing it to 'x' loses semantic information.

> Using the above symbols will just trick tools like grep for no good
> reason.
NBSP, sure.  That one's probably an artefact of some document format
 conversion somewhere along the line, anyway.
But what kinds of things with × or — in are going to be grept for?

If there are em dashes lying around that semantically _should_ be
 hyphen-minus (one of your patches I've seen, for instance, fixes an
 *en* dash moonlighting as the option character in an `ethtool`
 command line), then sure, convert them.
But any time someone is using a Unicode character to *express
 semantics*, even if you happen to think the semantic distinction
 involved is a pedantic or unimportant one, I think you need an
 explicit grep case to justify ASCIIfying it.

-ed
