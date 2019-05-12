Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7121ABC2
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 12:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfELKVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 06:21:33 -0400
Received: from sonic308-2.consmr.mail.ne1.yahoo.com ([66.163.187.121]:34648
        "EHLO sonic308-2.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbfELKVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 06:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1557656491; bh=hm2eWSdcZt5qZGI06OGG2BnJIZ3Akb6O3ATKED243Uc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=AKOIBVuZhFS0uX3WOFLZFtxka3TIlIwYCZHlwbpp+H0heiVaNptkancRgzKy9J1nRqc+5UcgjM2p9IpTaaxMiR7+DAEdhxEkXiqnzAcA0mYT/USAKBqIHM6wBWMqMrwf5k38XHbU2JPvAGLBvo6nN9RVcmDfx8aj/OxJXTnXy9LMxMeczyEK/VZpWkvlylbwpvdSEoMfLMgla+bLaH8R8BnZXXF0EH2YfvC/cE8Mji+n/FEyDzxo7ZiRLiNCqXC5Dl9CxOwNSSEIyw5fspmY3zijW8l5jJNmBcQ4tHIk/hwAAPU2CRs7eEmRK+DhrjcxISRmuyAFZwluLxjC/uUNag==
X-YMail-OSG: Uhyn3loVM1kI3DvUPRZcMQXBeUGa2CJGN9EoP4JH9ZEoiqa3xu7H33CSU5qOjfU
 0A90KhVpjS5Hf5.Z173Jdwb3ieAJzw0gHhFJ7s3Ce4jK0PJ7mnjPbgNGQMWsNF8lvEImBHQKw3RP
 k7yImBO1pqhy_mTZEhsmyxBq3oWWPgdvFY65P2hz1fNlTNa_lvoSwzWvPgdZ3bHlKP1VFLhMF2zN
 1ZDRfx1HhSnWfOcgpphGp5Y2m5g5rwGZcuXdaaRw2VwZsKC9Rx3Dh7MzOu4fBICfB9Do4CZMngDo
 tMcoGceueZMsLesgm1NSIOQGmULL_oHnhK2E_fFLDNzjMl4usH4Gry5.QDhvNhW9IA8PmcrH2vA5
 4uKprkGz0ZP5i6UP4idepKZ01BDGKOCTkYOJ3LjRg8WWeS8AZ671PTpjHXC0XJNlA8g5eXeOpFFs
 V6AsAb2THJHl194B2.OWk3Wvc.Gv2EQ9aaqTTqdqj7LDTS_DORBhiTWtOiANm_VQOoga5xJNRXfB
 NJAmNAfiXXxU87ZQIbNxhbC2Zu8uf1MqYjJLq8jts2GVR6UqvXA8SxZZAyKtv0oaM3FOBbVdIUaF
 tofPYDE.Mq22peVK_ax5p0OCts6sx95PZ_Ca0DIh2zynF.H8tLygn5BXXu4Uzy3V9q3mRXZIfr8a
 yZROfTe6obRSdedbhy60iRi1uePhDkpvNFqtkmhZnTLmiKfAhL04oqcmo0HO_ZcGnEeOxb.YuRtN
 4GtWUSGLoVz0UalW5S6..xgQXz7U6gv0u8PWfkD.ZqeNy860bJlIvd5oBzum8M31EZGrMhQOaJC9
 3bxdYWLwp3HVLIYimEluBrO7jIc_WloOiLSouygFJJ7A840HQnlJSNjTNKcI2qEvpIPw6T3RUfjz
 bRgK8Wd6TG9L1viv2di4KOV.B1m1vf3Tca.E_VayWh6U.ln9bK2clBhy1d3yvQy10BCrXk3VHZkP
 CjmFK648ZdxGj7kWMgQsROkFoHUAITg41GVYP3m9hGASjtLLecRmBzAjwnpfHBoyLpyPkH9ODlWO
 2__7Si1zkRh0pd6jPXHQCAC4RRFUNzRyvP62EyNHi2C06kbg2U7DnhKEpYJxgEx.0Fyt3EXT00bb
 2gtlQwv3GMIXKw9AvVHxFzSLrRGQwGW97.Od_8QHKQBHTTtQERi94_mAl7WhMZeCq305m_lOas.c
 PdrieGTTZp4pgw.CMFO05RhF.Gy2Iyo2x3UXLIoA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Sun, 12 May 2019 10:21:31 +0000
Date:   Sun, 12 May 2019 10:19:30 +0000 (UTC)
From:   Major Dennis Hornbeck <aa5@gamtm.online>
Reply-To: Major Dennis Hornbeck <hornbeckmajordennis637@gmail.com>
Message-ID: <39230425.937372.1557656370013@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <39230425.937372.1557656370013.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13634 YahooMailBasic Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I am in the military unit here in Afghanistan, we have some amount of funds that we want to move out of the country. My partners and I need a good partner someone we can trust. It is risk free and legal. Reply to this email: hornbeckmajordennis637@gmail.com

Regards,
Major Dennis Hornbeck.
