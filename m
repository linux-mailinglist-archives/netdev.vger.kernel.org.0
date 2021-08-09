Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044443E460C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhHINFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbhHINFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 09:05:45 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37302C061799
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 06:05:24 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id kk23so8210229qvb.6
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 06:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=blegdSx1GNY1kZ/BTfTNwYLedKQJMtRqMFiwOm5ZRFA=;
        b=S8lRl/xEd1bxfjSAjbXsWhXxVaOK88XpGLw3VbtL9d2Bw7WyZ1vyncEzsXwI4InrBH
         JifqB8w8DTfNooLeseQ0s4owzGeIMTAVPmRe9nX37qmOn+bnBPdXAOswfXirzw5sLbDF
         2IOeDzfioSO4Jsaqhjh4BUfWU2vdE+0YjnZU6IoeGiaNjTa5/4xgsvhIUdgZayieQuB1
         /ewo3Vuqg/SCjhmdjs5Az34IwrZG0sif+WeF/HG/Ka+7eOxwcADzcarDdx/k2w5WbWXo
         iGDhX4vo5vDcteJH+gS5I5UF8q24xc0yaPyhhKpqGu2k4HRcC/VU3PWXCDRdYWPT72xV
         EsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=blegdSx1GNY1kZ/BTfTNwYLedKQJMtRqMFiwOm5ZRFA=;
        b=T7R8TBEx4EN3Wbq7qAJMJ+MlZgqr+VuGSvwNYDdZLIrjqLVnFdF70HV1amNGBZ50LA
         dF68RfF+fYuMDHqmd1N/n7YMNDIuiFjsWSG8DGyS92T1mZJ88xwDYS1rS8cYmK+fVRkV
         HP8wpKzdoBCw+125HIrpkw+z1GvWm+ysypfAnhFILZ8ZvlXSx1PVlO4+WCXfK9EiqvXw
         twvQsY1bYAKvJc5NkbAZSQr5ulvFBt0x8bwLcyo0T1jGGY4Eyy5BDzRAMCaXnKPKKywP
         CUBMjMjI/a1GY4+NHi4SD41vwBt5I/CuFlxIWIWM/stsHSKezmtWEKSUPCg4uAzYe+EC
         DmcQ==
X-Gm-Message-State: AOAM531Ys+1H53j97/oPMLRiA1VRLdoa/V2BmGqpWnEH7NL8mItWKRJe
        gRP/bZ1Dwe22KKzCHovqn1OnBlhl/lXKXWHVbSk=
X-Google-Smtp-Source: ABdhPJwyJ3/lJZgpEi+7RCnjUT9sVd1sUShoGVnAmdXKywP2WsDcCdthMJtD5HJt9RGI5gw+Ay3cfj6cO7uojhDnxgA=
X-Received: by 2002:ad4:5884:: with SMTP id dz4mr23327881qvb.34.1628514323373;
 Mon, 09 Aug 2021 06:05:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6214:27eb:0:0:0:0 with HTTP; Mon, 9 Aug 2021 06:05:22
 -0700 (PDT)
Reply-To: jtmkba@gmail.com
From:   Juliet Mekaba <robertadolf1965@gmail.com>
Date:   Mon, 9 Aug 2021 14:05:22 +0100
Message-ID: <CAK48iza=1P_JQw54vxWBKYEWTwuhQ4ag8YuqfZWOk5sniEwfNw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hallo,

Ich habe mich entschieden, Sie zu kontaktieren, weil bei mir vor
kurzem Lungenkrebs diagnostiziert wurde und der Arzt sagte, dass ich
weniger als 6 Wochen zu leben habe. Seit mir diese pl=C3=B6tzliche
Nachricht bekannt wurde, denke ich =C3=BCber mein Leben in der
Vergangenheit nach. Es ist schmerzlich, dass wir nach =C3=BCber 26 Jahren
friedlicher Ehe mit meinem verstorbenen Ehemann Makeba das einzige
Kind verloren haben, das unseren zahlreichen Reichtum geerbt h=C3=A4tte. In
der Vergangenheit habe ich angemessene Spenden an die Opfer des
Erdbebens in Haiti und k=C3=BCrzlich an dieselben Opfer in Japan und
Thailand geleistet. Jetzt, wo sich mein Gesundheitszustand allm=C3=A4hlich
verschlechtert, kann ich all dies nicht mehr alleine tun. Ich habe den
starken Wunsch, den Armen und Bed=C3=BCrftigen die Hand zu reichen, aber
ich w=C3=BCrde es vorziehen, dies mit der Hilfe einer freundlichen Person
fortzusetzen. Ich m=C3=B6chte, dass Sie die folgenden Fragen beantworten:
(1) Wenn ich Ihnen 15 Millionen f=C3=BCnfhunderttausend US-Dollar spende
(15,500,000.00), k=C3=B6nnen Sie diese dann sinnvoll einsetzen, um meinen
Herzenswunsch zu erf=C3=BCllen, arme Menschen um Sie herum zu unterst=C3=BC=
tzen?
(2) Werden Sie im Namen meines Mannes und mir eine
Wohlt=C3=A4tigkeitsstiftung gr=C3=BCnden? Ich m=C3=B6chte, dass Sie in mein=
er
Erinnerung ein Heim f=C3=BCr mutterlose Babys einrichten, wenn ich weg bin,
und dann 40 % f=C3=BCr Ihre Bem=C3=BChungen behalten. Bitte antworten Sie m=
ir so
schnell wie m=C3=B6glich, um Ihnen weitere Details mitzuteilen.

Gott segne dich.
Frau Julia Makeba.
