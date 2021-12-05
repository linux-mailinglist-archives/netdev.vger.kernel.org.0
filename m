Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5A6468BC6
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 16:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhLEPhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 10:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbhLEPhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 10:37:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881DAC061714;
        Sun,  5 Dec 2021 07:33:50 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so6356339pjb.5;
        Sun, 05 Dec 2021 07:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:subject:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BfVQ341r1HL0CwbS+QuTV/gqbtW2ay4ttScIrn2iNUs=;
        b=LOYtUx1JbMJDzcmIU7d9yn3n0N8vVrqU+CtMScHaWDK1p/zGBUFKIF90FBjBdpxcDc
         WHL4gwQxCD8vi64Z+c3vg5bmuHDjAW66BRyj9KnYfunPdplutveKsLigh/MT0wDIMRgh
         1HP0O8glrcdwuY40UjZsFSRWrnP+6NeRU7S8nFdQowl0Lz+gXyN+vVBYWXvpYNMNP3vD
         qlA1u/56J+rW9HNss2r2iBdkH8QTsTIK9U0lHEU6tYch43Utzhsy1gLIl6wr5L+Ql9fK
         DEC30htUHx2mnD2dmLFVFmZVBxdOPjYn9U9JCSgdHpzaHpANrDMu757AkHK97OA4k3+S
         zPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BfVQ341r1HL0CwbS+QuTV/gqbtW2ay4ttScIrn2iNUs=;
        b=e4zzoifeWOywgMbvOR4JW1hTCBglI7j6kNMWm6MsdCMwgblBoyqnEsQKYhlW1NNgPy
         U8EafogS0J7tAv/x6PmWivtmdM9zNLfMGTMJJVQRyuxjdleCKozYSs/XlAwP3TbFwiRo
         YvEVgn1bG9q+qwCg4UBKSKJlz0exHxZfRS5GgG2qioqUwjzAFengvMe6kXy2WjOyegTD
         qq1fEvjpF86zF6w+MLJV0IPOOlA2LinoNkjC+iQxjkyfY9bmxySjrLmlNI19VRbOzCO0
         qRYdcLAqas7e9w6IGdsiMdGxqaI/SvTR0iHV7285Jm/TtShDCNDsvS1wZ3hM/4O9dgBF
         I/Zw==
X-Gm-Message-State: AOAM530/bKetVPzG6NcPDQ5SKwejoYOIEI+CoL0NUD8def2tXcJZW7Ch
        II3eVAeBl3I0jFeiQZvrDk4=
X-Google-Smtp-Source: ABdhPJwtAWORSdbSUeDCQcRTFc2KVVEfK501eeF6E8YQT3uEAYZ2rHW5C9OemdMCprBgLOT3iimOlg==
X-Received: by 2002:a17:902:a40f:b0:143:d470:d66d with SMTP id p15-20020a170902a40f00b00143d470d66dmr37394472plq.52.1638718429949;
        Sun, 05 Dec 2021 07:33:49 -0800 (PST)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id d195sm7501739pga.41.2021.12.05.07.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Dec 2021 07:33:49 -0800 (PST)
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Yanteng Si <siyanteng01@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, chenhuacai@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Yanteng Si <siyanteng@loongson.cn>
References: <YazChnNvaEMHzCQG@shell.armlinux.org.uk>
Subject: Re: [PATCH] net: phy: Remove unnecessary indentation in the comments
 of phy_device
From:   Akira Yokosawa <akiyks@gmail.com>
Message-ID: <431bf51d-9ed5-a235-99e1-99dee50f7925@gmail.com>
Date:   Mon, 6 Dec 2021 00:33:45 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YazChnNvaEMHzCQG@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On Sun, 5 Dec 2021 13:45:42 +0000, Russell King wrote:
> On Sun, Dec 05, 2021 at 09:21:41PM +0800, Yanteng Si wrote:
>> Fix warning as:
>> 
>> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:543: WARNING: Unexpected indentation.
>> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:544: WARNING: Block quote ends without a blank line; unexpected unindent.
>> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:546: WARNING: Unexpected indentation.
> 
> This seems to be at odds with the documentation in
> Documentation/doc-guide/kernel-doc.rst.
> 
> The warning refers to lines 543, 544 and 546.
> 
> 543: *              Bits [23:16] are currently reserved for future use.
> 544: *              Bits [31:24] are reserved for defining generic
> 545: *                           PHY driver behavior.
> 546: * @irq: IRQ number of the PHY's interrupt (-1 if none)
> 
> This doesn't look quite right with the warning messages above, because
> 544 doesn't unindent, and I've checked net-next, net, and mainline
> trees, and they're all the same.
> 
> So, I think we first need to establish exactly which lines you are
> seeing this warning for before anyone can make a suggestion.

Just a hint of kernel-doc comment format, which is not fully covered
in Documentation/doc-guide/kernel-doc.rst.

I think the diff below is what you'd like:

----8<-----
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 96e43fbb2dd8..1e180f3186d5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -538,11 +538,12 @@ struct macsec_ops;
  * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
- *		Bits [15:0] are free to use by the PHY driver to communicate
- *			    driver specific behavior.
- *		Bits [23:16] are currently reserved for future use.
- *		Bits [31:24] are reserved for defining generic
- *			     PHY driver behavior.
+ *
+ *	 - Bits [15:0] are free to use by the PHY driver to communicate
+ *	   driver specific behavior.
+ *	 - Bits [23:16] are currently reserved for future use.
+ *	 - Bits [31:24] are reserved for defining generic
+ *	   PHY driver behavior.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
  * @phy_timer: The timer for handling the state machine
  * @phylink: Pointer to phylink instance for this PHY

base-commit: 065db2d90c6b8384c9072fe55f01c3eeda16c3c0
----8<-----

Using bullet lists for bit fields is a reasonable approach,
I guess.

For bullet lists in ReST, which kernel-doc is based on, see
https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#bullet-lists

Just my 2c.

BR, Akira

> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
