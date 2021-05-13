Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9DE37F4C5
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 11:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhEMJXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 05:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbhEMJXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 05:23:44 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB16C061574
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 02:22:34 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id u144so200426oie.6
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 02:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=s8vDi8IacwsAjoxAt+TwpipYivdLvkNuOuJDoPMgoHM=;
        b=na9qPa9RwahSzgL5NVq5NPIdC/eZvGcjYfojqT6y1dJA4Z50p/G7NwK54YzQuItr8E
         dfkW1zzLbShsqQOfUmVMzJylyWdrcIEZxNgzwP8kFi3cwFr5Mz01CIf7D8H8oSLBCDCc
         x0yQ0fKcH+gYSXg6cKEj8vV1GkFz6CKs6hMVU8hUP1/4cG8OomcSNFH5HowErb/l98BK
         HP4E6ye1yIWYRK48t2wyBUEglgqzxVcthMqC7zEzawF3eGIalTcvK7Ek5S09iNu6EWCH
         cG8xWf0DhHdSadYJTRs4XBx8Z9tUbPEHUTTIeJzE0KwKGoah+iH4uauEqUfA9bUkdyue
         qaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=s8vDi8IacwsAjoxAt+TwpipYivdLvkNuOuJDoPMgoHM=;
        b=phOXUUNq14YHM3maoKeCto14zWQ6XRW3wOShA8s4Y5WKHeRE2KPHaK95WREOLFOHGY
         lgb8AZ+OmJyRFmAL6v/qx5SwAZaIzOvHQx7qD/627Hm9oBkMNQP14S35iCUkFKsVkiFS
         Tb/pwlrtDEaoFfE2kBEFKRwIWppPYwW0maHbwvgdKteh/Jwg0z5ChjUuHJ5ykAfUYfLB
         HelthypbjZRBM4T0NcsT8DipPHmMf0AQEpx3oHYsLnLkMhotGRietwlukahBP1tpZw7N
         xF8kW63EohRE2HK7rIxzJ3MeTwhLrGS0hu6C4qGnmvOeaVw56f359H4IDGCmLF4D2npV
         8XCQ==
X-Gm-Message-State: AOAM531jjU3JuVsyOeMjzBVwGVaCBXo67HmbT35skDVI2bcwbrLoXcFv
        qXXwnZjSmfN01TS31oL6FiGVeiPAcczKP+pm3TA=
X-Google-Smtp-Source: ABdhPJwPj6Mv392sRL/j62sPYBVz5/Y6Oj09pPrULutTOHkYKx1ltfkqFKI4Wlxg7HP4WuvSUodvEi6yu7P7wfyXX9A=
X-Received: by 2002:a54:4184:: with SMTP id 4mr2288495oiy.72.1620897754380;
 Thu, 13 May 2021 02:22:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: bisma.abdulmagidbreish@gmail.com
Sender: lindalaboso2@gmail.com
Received: by 2002:a9d:c43:0:0:0:0:0 with HTTP; Thu, 13 May 2021 02:22:33 -0700 (PDT)
From:   Bisma Abdul magidbreish <bisma.abdulmagidbreish@gmail.com>
Date:   Thu, 13 May 2021 11:22:33 +0200
X-Google-Sender-Auth: loYhn5dR4vwZosfPWFb2FX5ChFk
Message-ID: <CAAG+hxNwpKrSiCBiKygEO0nMkU-aM3ToJNafQbp6VJUzmbEoYg@mail.gmail.com>
Subject: Greetings
To:     naira.ruiz@yahoo.com.br, nalinidave@yahoo.com,
        nananda.1@hotmail.com, nancy.430@hotmail.com, nancyedale@aol.com,
        nathalie.fragoso@gmail.com, nathalimachadolima@gmail.com,
        nativenyer@hotmail.com, naudrhexpertise@gmail.com,
        navarrg55@gmail.com, navtejghumman@yahoo.com, Naytust@hotmail.com,
        nazare.machado@yahoo.com, nazifi.aliyu@yahoo.com,
        nbajerseysstore@hotmail.com, ne@yahoo.fr, neljouan@aol.com,
        netdev@vger.kernel.org, newjerseysky@yahoo.com,
        newsroom.thederrick@gmail.com, NewtonOsborne@aol.com,
        newyorkcitylens@gmail.com, nguyenhieu54@yahoo.com,
        nicoletbg@hotmail.com, niederkofler.felix@gmail.com,
        Niggabambam@hotmail.com, niharikamishra@hotmail.com,
        nikypp@hotmail.com, nildallk@yahoo.com.mx,
        ninasousa81@yahoo.com.br, ninivefm@yahoo.com.br, nio@fiocruz.br,
        nkchristian2000@yahoo.com, NMach41032@aol.com,
        nobline.felix@yahoo.com, noelia.libras@gmail.com,
        noicama@hotmail.com, nordictemptations@gmail.com,
        norma-10@hotmail.com, normampm@gmail.com, notaria17cdj@hotmail.com,
        notaria224@gmail.com, NotchesBlog@gmail.com,
        novesete.site@gmail.com, nufisc@tjro.jus.br, nugraf@tjro.jus.br,
        numerique@cultureslsj.ca, nuriescude@hotmail.com,
        nusea@tjro.jus.br, nuseg@tjro.jus.br, o_sfa.09.12@hotmail.com,
        Obertan.felix@gmail.com, obras.hn.rs@hotmail.com,
        odairmachado2008@hotmail.com, oddorosomi@yahoo.com,
        odishatt@gmail.com, oes@tjro.jus.br, ogi.group@yaoo.co.uk,
        Ognjen.v@hotmail.com, ohmonbateausup@gmail.com,
        oladunniliadi@yahoo.com, olakunlebakare@yahoo.com,
        olga_flix@yahoo.com.mx, olmstead43@gmail.com,
        OloOricha93@hotmail.com, omfed@yahoo.com, omodochris@yahoo.com,
        onboardgamesmailbag@gmail.com, only1_06@msn.com,
        oonafi@hotmail.com, opnieuweenfoto@gmail.com, oscbmd@gmail.com,
        oskarallende@gmail.com, ousmanesoh@aol.com, ouvidoria@tjro.jus.br,
        oxxx@aol.com, oxxx@medstarhealth.org, oxxxxxxxxs@capgemini-gs.com,
        oy@aol.com, oyeniran@yahoo.com, p_piroska@hotmail.com,
        pack.machine@aol.com, packaging.uy@gmail.com,
        packmachineindia@gmail.com, palabrasclarasmx@gmail.com,
        Pamela.Solis@ngc.com, paosho2002@yahoo.com, parste61@gmail.com,
        parvisespaceculturel@gmail.com, pasagba@yahoo.com,
        pascal44d@hotmail.com, pathy1599@hotmail.com,
        patriciamandy32@hotmail.com, patrimonioememoria@gmail.com,
        patronlott@att.net, patsromo@hotmail.com,
        paul.andre.bauer@gmail.com, paulavirginiarocha@yahoo.com.br,
        paulianeamaral@gmail.com, Paulodamin@hotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
MUTUAL UNDERSTANDING !!!

I am Mrs.Bisma Abdul magidbreish

Please forgive me for stressing you with my predicaments as I know
that this letter may come to you as big surprise. Actually, I came
across your E-mail from my personal search afterward I decided to
email you directly believing that you will be honest to fulfill my
final wish before I die. Mean while, I am bisma.abdulmagidbreish, from
paric france
childless and I am suffering from a long-time cancer and from
all indication my condition is really deteriorating as my doctors have
confirmed and courageously advised me that I may not live beyond two
months from now for the reason that my tumor has reached a critical
stage which has defiled all forms of medical treatment.

Since my days are numbered, I=E2=80=99ve decided willingly to fulfill my
long-time promise to donate the sum of six million eight hundred
thousand dollars $6.800, 000 remaining in my foreign bank account over
9 years due to my health problem. This fund was obtained by me when I
was dealing on Gold. My promise is to help the widows, handicapped,
orphans, underprivileged, to build technical school and hospital for
their well-being. If you will be obedient to assist me fulfill my
promise as I said here kindly show me your first obedience by
providing me your personal details to enable me introduce you to my
lawyer as the person that will help you to procure any document if
requested possible to transfer or deliver my fund to you.

I have been trying to handle this project for the past 4 years by
myself when I will get better, but I have seen that it won=E2=80=99t be
possible anymore due to my condition. Please get back to me if you can
handle the project for more details
Thank you
God bless you.
