Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A90627BA63
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgI2Bko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:40:44 -0400
Received: from sonic304-21.consmr.mail.sg3.yahoo.com ([106.10.242.211]:36865
        "EHLO sonic304-21.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727205AbgI2Bko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:40:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.ph; s=s2048; t=1601343641; bh=qmSSqPbMhLcDXCUTou/4ZHdNOAZhmLwgIXYfWUeeTzc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jFOXhi+CzUGsENApxC4oX6l01te/8njOMP38Ilxf/dHxu7WYb5/SdGyFe/tRii8S396pyb5vl4oe/IYp/afxTF+knHfoH0XxCWZ2H+WtCaOF+nu2n2Zcg3R+b30/6RVU9uirwAorfToaTYjAZe7pGsYeZi4UfF6C3PzSoQSC4YUdY0s0UaA0gA2BVYWjyVKcpxtOy/e5kuZ6AmRp/PZ1s8huxkL1NiZB+TYjCXB47DpzKSt+wQYgtiC1wGzJqniEAfQFsc1BBGzDvuFmM/JO9yUe7L6yA5jUfA2vxPXUYsLRXF+MAu2UtExYgdZbVAU24NZN/gdi6Y37b1TthRApVg==
X-YMail-OSG: Qtt.DI4VM1l18Ok62PWecVi5iRYTuiF.81MOGr3hm3KsqU9iZOSdnAO_fFH98wP
 8Cz7K6dPtfQ4EAylCfPlsP015zcwDkhezKmoJc2OifPBmVyES.EeRL.RWUwOS45m9_bIPuDiDYlu
 Kj2RVX4RkXeu.laVEyaGt0gKNSECokWoBC2a0f8eDC7YS3XbgmuOPvwPipTT6IJ1ZmIrevZmDoXN
 2mEOvLxig4ZwvEYKkjtVZOwvoQNwtzqDPhLHqCBpx6h52Ex6Rbt5u9sqpS1YTSMbzvX66QX.drQ4
 pfZWhbfVTKg0bktuk9sXuGh7ZQ7HLTinP4PISZ.eQA1XWErQ3jUGG9mjMLDF6vo95Oezzf97Szcw
 xoq9DP1liZa7vkqM1prxGm.PlvXuTA4LURzfQ.Jb34k.h.CHfLeGUVSnQOXg0qKybAcQ_ZCrJB91
 2PeUuvIiO39tu7Z8QV77Wdd15jEZmIhlLJC_Nkv9pB81Ngn8TvoywzdkXnWyfWUCQqBxrw3yPgY5
 pX.QJOTLuBcJ0P3V3xXvoppXyITz_bod0_S1ftutydv8c_1uyhvRH__tjXI8KuuTGR9TnQ_KufGJ
 U5JRCQNTeqyHEMv3_j81NV2O1fxsHWEwK_8r3zoo1TYTMM0jtDKtc_91wTNDPJB1_JFwyg_48nwZ
 qYa6t0YnTXIPSce4g_LdT9tvv6cV42Rku0ksqmKVEA.PKrsCagooBLEietgx2EDDITrxPJwmcZu7
 I_CDLbvYw1BHYgxT0e6EDxvVlM7fUjlHVNaIdservQkIm2IPJVVwAILwX9x_qx.TgOd4ldt3bFgM
 .RhM3NRk7JRHze4I2DTgfFETEaKND218wMTPRHQBenp8kHhvRvFDHRrTJ2shFy9C8WSqnNp3OyPM
 Vsocy45WMzNSklOEi1fo.1Fh5rawh8NtFzfyCUvvLVtiqNCB76m4APkYaBW20gMviUjzl01owf8j
 7F9Mf6Fz7z9lS29WN4A2RN.opp7hdZHJBdizoxVWgepfgSFtUkAzqB4IksFQOD8x0LHa5K23jaWI
 xR0kCzEDxzl2GDkUoa6WlaCXXzSR8DrPqbcmag4YoJvHrydjswhiW0TxahvmI7aQO53iUwBp8Wey
 0cDzRkhk8gIfj8_70t0rn_.gZowcUWEK2PHwJA8HWHvlh28lcRGTksDvuqJPG9HoGiQrC0JcFHFD
 1fy6v5EzBraESZmInJlLGseLAO4wZ53UXFekjfM2Y0be2rfHVEZfi0_PBitX4.rvAVEMxYf.wA6v
 zCWw4lR7VKqVmtAchnQAtbx_M2VGgcPJaJH.zC1O7x8Vo1ejjs369__CTaAtQ3hzlrt7Nu8TMPyu
 vMGjCbDdUeqtR8Hwp3eiB2CaeBU2By5h0JfZgdeBowcJ0oxfKSt4xUvj3N1NWr.gYzsJpid5jkMR
 x_iNNU3_kFpcdqtTh1KpkEFkVGilk8D850u5QVP9bHmZ6cHz56CbtaA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.sg3.yahoo.com with HTTP; Tue, 29 Sep 2020 01:40:41 +0000
Date:   Tue, 29 Sep 2020 01:40:08 +0000 (UTC)
From:   Alex <alexm200922@yahoo.com.ph>
Reply-To: aj3574935@gmail.com
Message-ID: <24059861.28437.1601343608908@mail.yahoo.com>
Subject: experience
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <24059861.28437.1601343608908.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hi

My reason for contacting you is to know if you have investment experience, to assist guard me invest in any profit joint venture as partners.

If you are interested and capable, respond for more detail to see if you can do it.

Sincerely,
Alex
