Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9D814FF33
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 22:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBBVKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 16:10:35 -0500
Received: from sonic305-37.consmr.mail.bf2.yahoo.com ([74.6.133.236]:40671
        "EHLO sonic305-37.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726967AbgBBVKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 16:10:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580677833; bh=VxFSqOLnoyhxZXWK73TPGK3hr8yutZ4yWmLQa/jSY/I=; h=Date:From:Reply-To:Subject:References:From:Subject; b=XFugQFBJgh9kzqAi2bDTLfXrflGW+Aa3sXSIFyJK8glLQFbFkZTWYTTng+GsjdYgDvo454n+A05Io3u9xQwdr0ejuztdlp0zzy9XJlLctnF4IJ12xnAV2ofS6E7a4OBLyFIrSBerOIsec/6LfFLDbNy8CcWoCkpV2y9XzkbLXs1EC6m/ak04homkju3KDCmaYdHhoWDXrXT970ENEuWeJM3jY2skBIduux/7L0QX4TFVeiXVyEk9PNhNqLQLf7HwxTXz0uzNhLesA8tFE0pvpHNyl5Rt2J4ZkIm0vt3/a9yrWSJhdbdAiKac0maW8lVNxhajdoxXabmBnrXhy+S6OQ==
X-YMail-OSG: zh7qJYIVM1m_FeD5I.zXf7FSP3_QfZl07gcJUh9i0G1Lermaehx.paxC3crvxaS
 .ugKiidzRFcn3_p3geSIH.Is.rOxgNRm6Mg.tjQKu19b3dJfrgXy2KcrHtFEoxaZhhPaxuR88ZQR
 x.2wpCK.N.LAmy13tY1JoBBPLCy9bLw75tSnpJMhUMs0Hstw2paV47oMIfpkbFuorPbaX44mRoOk
 BBC4ccx_AzGVS0BQ2JD6U1w1qIq4KLp5ByNsksAqE0mBxRhfcHn.7oUUXtvGpXn3.pdPh2x4UZtd
 ..I.wNdJ_2JDq6jx4Mopgyg1YkoS03hr9fxgAmmESYfCrhVQ1UXSOuJS7ouKv8VM.ozzHh39VrBS
 X_fTPe_vaE3UQaMA30Q8XiJCYm55xqGm1T0kZ7A96lUt2NmNQmk7uOS6KkTSeOqDPS6ZKyFhEcuq
 YrsWiy0FuK5iu3FrhjUgQb7gbdG0h0qaai1hbrnMbJ1r31hjv4C1ef30vYNWfeZweqzavvFEKg1S
 IpICx5lwPr2atZZ6ju1tVuekfUKtJ460rPk97D8BuH.5FffjPeWGcE6IOuD5CImaIzlDzaUpyp2O
 sxJV7JWm_X6Z9LBKbUQOr198.W06HuD6tdsAxrhhEKoSzodXFP51UkR8jkyX7hDGRhFEi2.a6ETq
 v9w0nND1cauEO1x48MDGxSiFht82SzAVoKYzbkhdk1QZhZPHeYcDJWL2KtgVssQ222dtrKMdAHqj
 VfSla0ghGEY._1X3ob2ts3SFO5mdla.mEQSEUeIurSi1YkuB_GWUfVuOFd2C2HjyL7q2jjoiUJv1
 F_Z.3vzacyVXGEgntME.Bv3LfdPV_HgaGF9RSObrvB3DSNRazzRnuNm53dy8f_Y9WCk_hqIQIKBX
 X36eh6VXQm_EymKYDA.FDwWlO3S.FuEV3v7uu63ZJQ6AooNEESAUN5XBkMBchzI6gH46hmz67o3G
 izfZXLEofkOrwDgOpQ2n1oMFMDsJh88uF7God_qzA1Mi4A0K4tSEJMEHQh1Q9x0E9IUtfdMn1E3o
 RLt00aORMIUqKRMkusV_g7Lr367QZ.5V1KD77bvQs9vWMTtzogdqGaaHsxmHI43r1s1U1KWTzx8v
 uXH5vxcbOAIaVoDezwZUV04vMXr60FoyArVzbb3D2XnjyTuu684yRA9TlZn.zA.B2tofQLEd0erx
 jm4ld0x7IWG..hD5yL.QgRRHPPqZ_Q2BR0wWKDzYocmEzoM3fbmIpvGQJHGtUQj77S_s.YQapfgZ
 67HI0Q4Hng8XblCLf.fRAon6393yDuJbOMAflEpTf5Tidej8mwxrWeQzlmObszr.4XlilN3Re1hJ
 4wF7FFWRB0MKMHjJiMkLaIn5Dx8wXHSdjejcp
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Sun, 2 Feb 2020 21:10:33 +0000
Date:   Sun, 2 Feb 2020 21:08:32 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <dd34@gczao.com>
Reply-To: maurhinck6@gmail.com
Message-ID: <709835941.497249.1580677712921@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <709835941.497249.1580677712921.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15149 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36 OPR/66.0.3515.44
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck6@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
