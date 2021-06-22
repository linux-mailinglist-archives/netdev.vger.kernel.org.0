Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7CB3B0BBF
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhFVRra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhFVRrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:47:17 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8E7C061768
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:45:00 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id t17so17115080lfq.0
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dS3btp8q9c+2avwbntaDKWJ8C9VxbXvRz8WLJ2PiMzM=;
        b=KRjmuVQ1dDoNXrDrzSg0oFrFsCdnhvBetnnE/EDZH4ryniHUpwGs5NyN0M6et15M8h
         FzX5c+XWewBiMmaHmPz/JV6L/rLDk8HxsjsF0L8GEfy11r5AonuYoG8MZMJEzVCpCPdn
         A0idfrYOePsfS5qT36BbPixJLIjUM8hDc4NV5YMukqkajiJVBwqzmptKnF+mpgIEZG4m
         TGiHSWmF3YWH3ukz1ty8xjivS4flFvX00ttYl3AVsfE+GucI/7sDFecBdghF3ZbQrOjt
         e4EOM3m5JuAsazlKg1CfftvujbgtgrzlJBQ/JODLIRSzz+6wn1VNkzVXbIStPPCO4YJb
         CnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=dS3btp8q9c+2avwbntaDKWJ8C9VxbXvRz8WLJ2PiMzM=;
        b=dXW+ClxNiahbLbzPEM5o3mjhilLGBnGtT3cwyHWlXfyjYAXGUxr6RyVR7zs7tJ/37l
         kYpfMO5I2SgBr7hY/a3IKrn6ZQ0mvQ2SRu5oMnql6Qc8w9OqV+5rxNBy/zCzGTun73c0
         NDWrqoZqCF46pf3YE81Dn7CqCow/DVXgP+UFWuZPeG1WtVcVZn9RthmnAY0bz3g+yLAc
         85WbChxPeOTSFaxF9jTcUnKqXTiZsuQgIHlwnkvFjhByWKBn/zaXjJOTH7U80Cx8ZAEB
         HrDxkLVsi7VLy7FdUNb1SI7sk7+wg20j/J4ul5kzu1pcFzA1xHDntGQ8hqE+ydFhslGI
         fvJw==
X-Gm-Message-State: AOAM532m1KLXj6Rz2pPEDTgEUrtHhy0ZV/YYhhaSfdlZBvNQApN9/pwW
        XzgXDrqRGx5LPCKuohaDv5iCU6MU5XnPeNq+l04=
X-Google-Smtp-Source: ABdhPJwqwqSJPnQBE5wONpDYSage3WiM0uJJ5MVYDJlkpnRmoGIpea0beRDoCEHOGjoMjYP3v4RZ/AqHoccwzF0Ewqw=
X-Received: by 2002:ac2:5f59:: with SMTP id 25mr4009842lfz.454.1624383899253;
 Tue, 22 Jun 2021 10:44:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:b0fb:0:0:0:0:0 with HTTP; Tue, 22 Jun 2021 10:44:58
 -0700 (PDT)
Reply-To: liaahil100@gmail.com
From:   Lia Ahil <liaahil4040@gmail.com>
Date:   Tue, 22 Jun 2021 18:44:58 +0100
Message-ID: <CAEwQg3Eb-jZnuJmLZcoLB8f48FjUOkDGewM6h=oZtkMVW+Xcyg@mail.gmail.com>
Subject: Guten Tag,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guten Tag,
Mein Name ist Lia Ahil (Anw=C3=A4ltin). Ich habe Ihnen vorhin geschrieben,
aber Sie haben nicht geantwortet. Ich ben=C3=B6tige Ihre Hilfe beim Abrufen
der Gelder meines verstorbenen Kunden (8.500.000 US-Dollar), die bei
der Sicherheitsabteilung der Bank zur sicheren Aufbewahrung hinterlegt
sind. Beachten Sie, dass Ihr Nachname dem Nachnamen meines
verstorbenen Kunden =C3=A4hnelt und dies der Grund war, warum ich Sie
kontaktiert habe, um mich bei der R=C3=BCckforderung der nicht
beanspruchten Gelder zu unterst=C3=BCtzen, da die Bank mir ein offizielles
Mandat erteilt hat, den Namen des Beg=C3=BCnstigten f=C3=BCr die Geltendmac=
hung
zu =C3=BCbermitteln, oder sie wird es tun Beschlagnahme und Schlie=C3=9Fung=
 des
Kontos, wenn keine Reaktion erfolgt.
Wenn Sie an weiteren Informationen zu diesem gegenseitigen
Gewinngesch=C3=A4ft interessiert sind, wenden Sie sich bitte dringend an
mich. Unser Aufteilungsverh=C3=A4ltnis betr=C3=A4gt 50%-50%. Sie haben
$4.250.000,00 Dollar als Ihren eigenen Anteil an dieser Transaktion.
Senden Sie mir dringend Ihre Informationen
1) Vollst=C3=A4ndiger Name ----------------------
2) Handynummer-----------------
Gr=C3=BC=C3=9Fe.
Lia Ahil
E-Mail-Adresse......... ( liaahil100@gmail.com )
