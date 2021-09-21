Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FF1412EFE
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhIUHE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 03:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhIUHE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 03:04:56 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6496DC061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:03:28 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id b65so573057qkc.13
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=kfDlQBVSqf07hAXhTAUKnH/OI2lCXLrpWHu75WLFvTA=;
        b=QRAsKjEuNxL0ylxy/EMHd0widF38Pvwdu96p9ts6NK7tPeWY4I0N7lW2Z2sKkz3Poj
         n8xYS+RgoT/bp6brAFQ7SBWx7AyRn5VftyFhCQgJOFRoSDvrzjF9VQeXt3WXAY0HZTq4
         VIhPD81mduIebUgs5dTvawKUzMr86zcYnQ+gS2X+7MSLq1iKPoYQ7y2FEqceg83HHjh9
         ql5gUdOhuhwPpB0AxjmB152yUSuv1yeSrmuBzv3TyDIK+bfhqh0uR4tA59fcD/FfELHL
         anOgX/A1SIs/52lpZXjQj4e7wSciD3K8XRGJe1e8wR9RmeYoyJNzoMTeJdF4YXQ8jyxx
         6bzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=kfDlQBVSqf07hAXhTAUKnH/OI2lCXLrpWHu75WLFvTA=;
        b=Fz36VeV2nIfhLIKpzynxDcbQL58+o598HlgA7LC8ALwJDtaH+Ze/yEX9v9z1c+uFMW
         KGMtnmRupdrWM0BqE/M99KTRq4zUv9gm+ppCeZVJRVNm7Eo6z/UYSh2gF4OMXUGNYwt3
         hlc06JPFa216OAJVEyaDZWW5GYXYR/1TAQeKb+5SdhYSWj9a+rVpi9AcyqHG/LVcmQLp
         JRH3Jw+OR3z671qa8Gb0RN8oaR+NjwugOSClojcsoOLFa26nqWO86AugQifK8ba1NCo/
         Py2X3m6tSEb7k0fRDi+xe8kety+RsOhRzRkGU4tgCDKyNqcvK1aILzB1FTotx8IBkLF8
         8QSw==
X-Gm-Message-State: AOAM530cTzUZClNogPCh3+GhA0jmjUHEZ0GCzWTYsLQHuBDASu0cFJg5
        28o8T6268GVnMn1rUwlLr3ytVbyuoGSedLAZpto=
X-Google-Smtp-Source: ABdhPJwH3WoEcqQw14wn2tB7I8tMG0KJomQPS5Vt6uKDup7TRO39Olb+q2KMEJKcqd8/cbnHnzIc2YTVEzglwgNu6Eg=
X-Received: by 2002:a25:cc90:: with SMTP id l138mr35798273ybf.400.1632207807274;
 Tue, 21 Sep 2021 00:03:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6918:d290:b0:5e:224b:aff1 with HTTP; Tue, 21 Sep 2021
 00:03:26 -0700 (PDT)
Reply-To: michaelrachid7@gmail.com
From:   Michael Rachid <torrescorey23@gmail.com>
Date:   Tue, 21 Sep 2021 08:03:26 +0100
Message-ID: <CABmOKHqkJ8PMVe33wWBjaaUDET+Kn36MZ21JP0jyhdoyXvFaTg@mail.gmail.com>
Subject: =?UTF-8?B?15TXptei15QvUHJvcG9zYWw=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

15fXkdeoINeZ16fXqCwNCg0K15DXoNeZINeb15XXqteRINeb15PXmSDXnNeU15XXk9eZ16Ig4oCL
4oCL15zXmiDXotecINeU16bXoteUINei16HXp9eZ16og16nXmdepINec15kg15HXlCDXlNeZ15nX
qteZINeo15XXpteUINec15jXpNecINeQ15nXqteaLg0K157Xk9eV15HXqCDXkdeX157Xmdep15nX
nSDXnteZ15zXmdeV158g15PXldec16guINeU15nXlCDXodee15XXmiDXldeR15jXldeXINep15TX
m9ecINeX15XXp9eZINeV15zXnNeQINeh15nXm9eV16DXmdedLg0K15DXoNeQINem15nXmdefINeQ
16og15TXqtei16DXmdeZ16DXldeq15ouDQoNCtee15nXmden15wg16jXkNeX15nXky4NCg0KDQpE
ZWFyIGZyaWVuZCwNCg0KSSB3cml0ZSB0byBpbmZvcm0geW91IGFib3V0IGEgYnVzaW5lc3MgcHJv
cG9zYWwgSSBoYXZlIHdoaWNoIEkgd291bGQNCmxpa2UgdG8gaGFuZGxlIHdpdGggeW91Lg0KRmlm
dHkgbWlsbGlvbiBkb2xsYXJzIGlzIGludm9sdmVkLiBCZSByZXN0IGFzc3VyZWQgdGhhdCBldmVy
eXRoaW5nIGlzDQpsZWdhbCBhbmQgcmlzayBmcmVlLg0KS2luZGx5IGluZGljYXRlIHlvdXIgaW50
ZXJlc3QuDQoNCk1pY2hhZWwgUmFjaGlkLg0K
