Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE6F4BBAF8
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 15:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiBROxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 09:53:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiBROw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 09:52:57 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AEE46173
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 06:52:40 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2d625082ae2so68808267b3.1
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 06:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=qq9wIiVWHN2WAUtj0B7xD2yz2moOuwSz6aN0pUPieSs=;
        b=pR8Uw83t/EuJsBa8f+Fn4bN3Ha5qBNqVYjyUhSxHflBdO+Iy6E1foZ8dAZKBCJa2ff
         jrdJFIcWbRALEerBmYTF7dWdNQZvnByKBzzlDCMRyjTqSj/5l2tENMZNMTf6hIkuiaAX
         8YFdLwYtpPlGC8DzIPZ5kv28hbHLORhgLC320l7eXitFdxXmJsU5ovg6icRKQ/mWDcNw
         CNWg7j3EY3jt3IFd/u79L4uDOIGMsugDicbF4Bmc8n/VqdWm611rf89xxZ6m9jqLCv9p
         oFSb0OH9jXE3x665CdVs6LeBnsy/xXZ35XE7m97rKXVniIqQu1iq9BDqkQ3t6y/fi15o
         EfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=qq9wIiVWHN2WAUtj0B7xD2yz2moOuwSz6aN0pUPieSs=;
        b=Cd7QEeHd7NwMTKI4EdmpcC15EcQIqU1tTfuhanFJv2LuA7eAYHoDr7P6sA541PQcVK
         QSeyFLGGNoc1PLmO2SMp5tnl1PmgcQHdRKclsQt9ToNqjXRay+TZ/XKitxUoqNVsm2aR
         FVgkJ16eFJqECGVW9sFCbIkzMz1Zb0HTGZwoKwuchEhjHcjaEf6rBL0yZFxLxeYJfDVt
         FrmYXyNxxDr6Bqivc237moAw5qMprWf1YU394mEXWNu2vTc/xlKzm9fuxZzD/h4x3Ylp
         kjFdkiH0hIHLxTC0JVY3DcYn8BObRZSICkg6PqZDrrCtFthf+xPnznOJmsoeycT59xYc
         1K3Q==
X-Gm-Message-State: AOAM5312U385NMuUbFqjwR7r1JJaLLgYqEOd+IU9XM00QljtBRCkLSIr
        IUK9zhXcWkchU9aNz015Z2kCP9Au2JXe8ZkLu+0=
X-Google-Smtp-Source: ABdhPJzx6pbY9kfRLKj9Ig+7z4qY82YSDdHSsPymA866NQ24d6AZSaBn3PDAl8PbFMsxw3z1C1n4+p3iE/voR93Wqqs=
X-Received: by 2002:a81:5591:0:b0:2ca:287c:6c8a with SMTP id
 j139-20020a815591000000b002ca287c6c8amr7980784ywb.303.1645195960007; Fri, 18
 Feb 2022 06:52:40 -0800 (PST)
MIME-Version: 1.0
Sender: gerzayn3000@gmail.com
Received: by 2002:a05:7000:6f03:0:0:0:0 with HTTP; Fri, 18 Feb 2022 06:52:39
 -0800 (PST)
From:   Felix Joel <attorneyjoel4ever1@gmail.com>
Date:   Fri, 18 Feb 2022 14:52:39 +0000
X-Google-Sender-Auth: YNt6PKl9IC0WJhakI82szRt35-g
Message-ID: <CAKu-PTM_-_-2Dc_+AyZga_FuNAwJZWe0gHDCe2v2z8oCVNeo_Q@mail.gmail.com>
Subject: Vennligst svar snarest
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hallo,
V=C3=A6r s=C3=A5 snill, godta mine unnskyldninger. Jeg =C3=B8nsker ikke =C3=
=A5 invadere
privatlivet ditt, jeg er Felix Joel, en advokat av yrke. Jeg har
skrevet en tidligere e-post til deg, men uten svar, og i min f=C3=B8rste
e-post nevnte jeg til deg om min avd=C3=B8de klient, som har samme
etternavn som deg. Siden hans d=C3=B8d har jeg mottatt flere brev fra
banken hans hvor han foretok et innskudd f=C3=B8r hans d=C3=B8d, banken har=
 bedt
meg om =C3=A5 gi hans n=C3=A6rmeste p=C3=A5r=C3=B8rende eller noen av hans =
slektninger som
kan gj=C3=B8re krav p=C3=A5 hans midler, ellers vil de bli konfiskert og si=
den
Jeg kunne ikke finne noen av hans slektninger. Jeg bestemte meg for =C3=A5
kontakte deg for denne p=C3=A5standen, derfor har du samme etternavn som
ham. kontakt meg snarest for mer informasjon.
Vennlig hilsen,
Barrister Felix Joel.
