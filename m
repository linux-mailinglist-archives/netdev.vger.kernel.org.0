Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6652762CE
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgIWVE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgIWVEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:04:25 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F5EC0613CE;
        Wed, 23 Sep 2020 14:04:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id b79so1437136wmb.4;
        Wed, 23 Sep 2020 14:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=Cwsd6her1f525yiWhkcoGWgzKup5DnYJEVjSpYNiosQ=;
        b=I22w5349tDL/91cg3dlPigSanrcqoe3ZFWDo5dJ8hEheB4GawRg09zou8o/NwpfG3F
         eWMFwYbZEoCGTffezgkfmngro0y9jfqMvSHg73a7Spb3DssefsXQORUNr1lTPRW0Ysrg
         q37KVNtYbwlVet1sJBBV7GWs6PgjTnXEnP8pzMggpDDYwFUnj7RLAo8lDTImGgG9Bd9q
         xwJCg0gzsZLAlOLzQCI35eFJChlNFnkwGJKVwzwFzOJwn1XUgr6MctBJniQj/zvlE1Ym
         pi2jzPnyCAPhJsVnBwSlPeitDBADceLs8Mo/kn73wsxb1JteavBU6uSEbDhvCQjCLCIN
         /P4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=Cwsd6her1f525yiWhkcoGWgzKup5DnYJEVjSpYNiosQ=;
        b=r/i5lXXoKPErHfTkkuK/UTBqVp4Z35KLvFxAugymrbDxW1AAzbBTC5QV28Uch1Kxjb
         wOOZ2UoieI+8whW7MdIyuDs5AfKzXIbEd3Glh3xzLD/gUIiZp076ClFMk1TdZwrBMWu+
         sw8FOPh6TIEgR0g/nMkDDG8TESnHkruLMMalVA/irr3PnuF5q53Mm9Z1Jt0D3ZebJZS4
         ZIMvVzVQVMHCDoeWG2nOlLPBwxdHxnnHir6pBZT8FV0pH7ZeAs256PGYf2Q2TIz1vf4Q
         v9schOA/64nszrQf4fC9GD1gJCZIFWzpzbelrd3MFUJZpDIHJt33iS+j/OtQ8NhPw4ic
         aJdg==
X-Gm-Message-State: AOAM532Cq4nVghVC5mPvNYhe/4ab5rGqtua5e5RzWZ15lhsnNhreOGs7
        Q7ciFdz1ocq1bmv/v1NjLqk=
X-Google-Smtp-Source: ABdhPJynn45TaPmkXDi+yvz8LZCHR31hOdHMKqCvqYWpmPNtjSgxWbcuWxWnrcBjzrZC8KwmPTBOhA==
X-Received: by 2002:a1c:9a57:: with SMTP id c84mr1377989wme.136.1600895063600;
        Wed, 23 Sep 2020 14:04:23 -0700 (PDT)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id d23sm930906wmb.6.2020.09.23.14.04.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 14:04:22 -0700 (PDT)
From:   <ansuelsmth@gmail.com>
To:     "'Rob Herring'" <robh@kernel.org>
Cc:     "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>
References: <20200918181104.98-1-ansuelsmth@gmail.com> <20200918181104.98-2-ansuelsmth@gmail.com> <20200923205824.GA1290651@bogus>
In-Reply-To: <20200923205824.GA1290651@bogus>
Subject: RE: [PATCH v2 2/2] dt: bindings: ath10k: Document qcom,ath10k-pre-calibration-data-mtd
Date:   Wed, 23 Sep 2020 23:04:20 +0200
Message-ID: <019801d691ed$1bc26650$534732f0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: it
Thread-Index: AQMJH5wF5tFRrUdsk5f5BXXZ8/xBtQJaPmHMAl7msnGm69B+EA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Wednesday, September 23, 2020 10:58 PM
> To: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> ath10k@lists.infradead.org
> Subject: Re: [PATCH v2 2/2] dt: bindings: ath10k: Document qcom,ath10k-
> pre-calibration-data-mtd
> 
> On Fri, Sep 18, 2020 at 08:11:03PM +0200, Ansuel Smith wrote:
> > Document use of qcom,ath10k-pre-calibration-data-mtd bindings used to
> > define from where the driver will load the pre-cal data in the defined
> > mtd partition.
> >
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/wireless/qcom,ath10k.txt | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git
> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> > index b61c2d5a0..568364243 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> > +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> > @@ -15,9 +15,9 @@ and also uses most of the properties defined in this
> doc (except
> >  "qcom,ath10k-calibration-data"). It uses "qcom,ath10k-pre-calibration-
> data"
> >  to carry pre calibration data.
> >
> > -In general, entry "qcom,ath10k-pre-calibration-data" and
> > -"qcom,ath10k-calibration-data" conflict with each other and only one
> > -can be provided per device.
> > +In general, entry "qcom,ath10k-pre-calibration-data",
> > +"qcom,ath10k-calibration-data-mtd" and "qcom,ath10k-calibration-
> data" conflict with
> > +each other and only one can be provided per device.
> >
> >  SNOC based devices (i.e. wcn3990) uses compatible string
> "qcom,wcn3990-wifi".
> >
> > @@ -63,6 +63,12 @@ Optional properties:
> >  				 hw versions.
> >  - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
> >  				     the length can vary between hw
versions.
> > +- qcom,ath10k-pre-calibration-data-mtd :
> 
> mtd is a Linuxism.
> 
> > +	Usage: optional
> > +	Value type: <phandle offset size>
> > +	Definition: pre calibration data read from mtd partition. Take 3
> value, the
> > +		    mtd to read data from, the offset in the mtd partition
and
> the
> 
> The phandle is the mtd or partition?
> 
> Maybe you should be using nvmem binding here.
> 

The phandle is to the mtd.
You are right about nvmem... Problem is that nvmem for mtd is still not
supported. I already sent a patch to fix this in the mtd mailing list but
I'm waiting for review...
If that will be accepted, I can convert this patch to use nvmem api.

> > +		    size of data to read.
> >  - <supply-name>-supply: handle to the regulator device tree node
> >  			   optional "supply-name" are "vdd-0.8-cx-mx",
> >  			   "vdd-1.8-xo", "vdd-1.3-rfa", "vdd-3.3-ch0",
> > --
> > 2.27.0
> >

