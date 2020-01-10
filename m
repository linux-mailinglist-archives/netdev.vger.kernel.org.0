Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6262C136C1D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgAJLlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:41:31 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46664 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgAJLlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 06:41:31 -0500
Received: by mail-oi1-f193.google.com with SMTP id 13so1550454oij.13
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 03:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=LEWm7wDdJq9X0vNbM230lGGzTYZvVY/Vu/f0Hh7nrUzE3NmZIcEI/QNiGniYLUz7Lp
         UkDU5fpnuoVf6Jl308BuwlGTxmEvASqBRVdEInY8Jpfsd1l5Lezp7lW6sT1S78Qu8Ycy
         7rQECkxaVkU7S8vQkLKVOVSdikr57toJfshzIxxjQReE5Ih+not3BbzreCGiA74ZV9L1
         KOHog8ADGEc7x7x6FGtsLLrXJw/gu3N7vGFQiDfoTlTjPy2zkbg6dsftuXKsf7ZVj/i9
         D2sLJRfR3ttRu+nVmOAs9DpTw4DCMtQlOFMaDBoHdTJBuCMdnH7QynU4SdVPzaUdq/aG
         iMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=KBariCTBiQsinDW/1uK27Zu66yfqHioc7iiB62O06ZSj4wU8gK/HajdmB7HjcZQ5JT
         y8F1DKP+3i5gk30c1dh1UtbzFPiiqShnypw9Wyc5oSNg8sE8cNqyJ9niStp5iHylS8EA
         s/7p9UOMfMqeZfcTrB72UBs5kSIm0NStKyeJe6NMViMlUnA/ZssVBm1LqL+NNv80THdQ
         y5BFMOTW/urMCZwNTXxQpWtOBdrMi2/TXpCYbwoUm86U5xJfk8khoWYkjNG9JKFs86+u
         SxnY/RBWcbjsqaPzIbbhbB6lK9l0zlikvFj+13ibM3buK+oS4n0Z7+riPgBL0XG7F20R
         EgEA==
X-Gm-Message-State: APjAAAXSlSaKDDCLVDhFSsCiAskTXjV1YmHHyQj9dhWj9dbRk7ZnACVH
        fObN/IOAINrW9WZcWhOgxlJggJi6v9dt7c5VVP0=
X-Google-Smtp-Source: APXvYqzcB74Vlmk2Tfnr5nZrkmLZi8nB2LDGBf24FcaJcpOTmJ+9YJNZuqJCp44tHJTEjeWpr8d1j5gtO+G9oBehtbg=
X-Received: by 2002:aca:af8b:: with SMTP id y133mr1883544oie.73.1578656490810;
 Fri, 10 Jan 2020 03:41:30 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6e0b:0:0:0:0:0 with HTTP; Fri, 10 Jan 2020 03:41:30
 -0800 (PST)
Reply-To: martinsandpartners@yandex.com
From:   Frank Martins <sammande5169@gmail.com>
Date:   Fri, 10 Jan 2020 03:41:30 -0800
Message-ID: <CAKeoT+yJFsj1kv+Lkf+usJbK+6A5FG7Wf0R_V8iLpvUs8dQCAQ@mail.gmail.com>
Subject: =?UTF-8?Q?=C5=A0e_vedno_=C4=8Dakam_na_va=C5=A1_odziv_na_moja_=C5=A1tevilna_e=2Dp?=
        =?UTF-8?Q?o=C5=A1tna_sporo=C4=8Dila_z_neodgovorom=2C_ki_se_nana=C5=A1ajo_na_va=C5=A1_dru?=
        =?UTF-8?Q?=C5=BEinski_dedni_sklad_=2814=2C5_milijona_dolarjev=29=2E_Vljudno_mi_pot?=
        =?UTF-8?Q?rdite_to_pismo_za_ve=C4=8D_podrobnosti=2E_S_spo=C5=A1tovanjem=2E_S_spo=C5=A1?=
        =?UTF-8?Q?tovanjem=2C_gospod_Frank_Martins=2E?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


