Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D9E35B2CB
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 11:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhDKJiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 05:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDKJiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 05:38:01 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5B3C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 02:37:45 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id h5so3278449uaw.0
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 02:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6uFlNhp9AEb270lOfa5fXrMWT/gAGcsjjz9E/7U1oC4=;
        b=Wa1NVXtQDVYFP/nvEDtsGvnSATxMzognN28RIBKk8KeBh0OZMVttjgWGt6FETvR4r+
         v65ZEyzW8gTnByGutsgxqXo6q4boI8YYQoQsfYNuCE/k07ffpnssMyAREQXJkHF0C4Pk
         XOrlbWNdh9Ozv6s7LS12K1IXMBJwYrv4kG87UY9d2V2PYvZM16J45PP6/ckHFAihbZnP
         SJ2T1ISJYHKsPlIRcN+p+yZWwHVldZryAJe1L+qQAgqgpI6O5LiXdrM8FbtI1ZL84V9A
         MPTLwpRQOWcUYIISgdsg46eDefB+RTVx4fqLQnvXdANr1b4CrnX9/mo16F0EiBijGksv
         zUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=6uFlNhp9AEb270lOfa5fXrMWT/gAGcsjjz9E/7U1oC4=;
        b=T7PkCR7HgdAfm0Fwk9r2rlquc8GX3UHZI3IcftzV+atubnp199OSPA2m/Gz3nl+PVl
         LoB2fXZHqu/aC+JcA01FoB5dUXjH4S98OkOgET4rwx+GUrkcC4NvBb5osIItP5uDZ3IR
         RIcgGLurp98CyW8z2xTTreGEVfu7g2iYhQNXK2FJiLekXqxs1lUmz5pHQSmhUpEYZTaO
         ku6eJkyinNBNu5l4WtIBlFttYzGNKpFUq+lms4vvzFzn8Iaa0V7NKIyD5bxC/bsBQxMT
         wU/X+lLnp1jENyKhx5tSNWuTovsjF5BrTEytR5sHjY8brYzy/1Wbp598gfFy3HMOmB7w
         9uYA==
X-Gm-Message-State: AOAM532wrhqOPw+s0lhtVRW2/ryjlhkm8eVuuZ/MELwDyGLXfefMBewI
        DydCw+Ghlvy/wRSJS2THjKaGKHIt5ux84Px2n94=
X-Google-Smtp-Source: ABdhPJw3j+jYaczoVXVQesRrXztiN9FVJvAPN/D28nP95rI1VfIOupCiwW4sqRpxT+P2ufvMFfntEfxpmMYi/5tSmew=
X-Received: by 2002:ab0:3306:: with SMTP id r6mr12589013uao.72.1618133864404;
 Sun, 11 Apr 2021 02:37:44 -0700 (PDT)
MIME-Version: 1.0
Sender: jw542827@gmail.com
Received: by 2002:ab0:768:0:0:0:0:0 with HTTP; Sun, 11 Apr 2021 02:37:44 -0700 (PDT)
From:   Liz Johnson <lizj6718@gmail.com>
Date:   Sun, 11 Apr 2021 02:37:44 -0700
X-Google-Sender-Auth: TnJi0_Z4JnKAEt5OE7Ixo8Vm0rg
Message-ID: <CAHvq4XAH20RRpxuzMk+yHghBgzrbCa3YJ8FexYN75HeJW87hfA@mail.gmail.com>
Subject: Hello Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5L2g5aW9DQrkvaDlpb3lkJfvvJ8g5oiR5pivTGl677yM5oiR55yL5Yiw5LqG5oKo55qE55S15a2Q
6YKu5Lu26IGU57O75Lq677yM5Zug5q2k5Yaz5a6a5LiO5oKo6IGU57O777yM5oiR6K6k5Li65oKo
5piv5LiA5Liq5aW95Lq677yM5aaC5p6c5Y+v5Lul77yM5oiR5oOz5oiQ5Li65oKo55qE5pyL5Y+L
44CCDQrlvZPmiJHmlLbliLDmgqjnmoTlvZXlj5bpgJrnn6Xml7bvvIzmiJHkvJrlkYror4nmgqjm
m7TlpJrlhbPkuo7miJHnmoTkv6Hmga8NCg0K6LCi6LCi77yBDQoNCuaDs+imgeaIkOS4uuS9oOea
hOaci+WPi+OAgg0KDQrpl67lgJnjgIINCg0K5Li95YW5DQoNCkhpDQpIb3cgYXJlIHlvdT8gSeKA
mW0gTGl6LCAgSSBzYXcgeW91ciBlbWFpbCBjb250YWN0IGFuZCBJIGRlY2lkZWQgdG8NCmNvbnRh
Y3QgeW91LCBJIHRoaW5rIHlvdSBhcmUgYSBraW5kIHBlcnNvbiwgSWYgeW91IG1heSwgSSB3b3Vs
ZCBsaWtlDQp0byBiZSB5b3VyIGZyaWVuZC4gSSB3aWxsIHRlbGwgeW91IG1vcmUgYWJvdXQgbWUs
IHdoZW4gaSByZWNlaXZlIHlvdXINCmFjY2VwdGFuY2UNCg0KVGhhbmtzIQ0KDQpXYW50aW5nIHRv
IGJlIHlvdXIgZnJpZW5kLg0KDQpSZWdhcmRzLg0KDQpMaXouDQo=
