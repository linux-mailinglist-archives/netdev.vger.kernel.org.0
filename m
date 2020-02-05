Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F8315273C
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 08:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgBEHzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 02:55:40 -0500
Received: from sonic302-20.consmr.mail.ne1.yahoo.com ([66.163.186.146]:46727
        "EHLO sonic302-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbgBEHzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 02:55:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580889339; bh=YooljpITC31Cc9KXMfJzAPmr/1tCBEdX27fhfqn54Fs=; h=Date:From:Reply-To:Subject:References:From:Subject; b=CZLRjSzjk+gvg/DEZ3fwkdde8YiBz45xYO+89+prgBwCcFEmegDNsbwytPAnrtwOtyglVDfN4NH6wMcP4hbymIgp2xGpUUoQQnY4rXeQUA2CsJXpOpXQmbvHBV79uFscod3ukwXPPDA94fIwo2WzRhFs/ar8BpRIeBNkuAYObXcrStjQiVE57qu/I2o7p42GPH7X3SPZEKTLxfFRYUOpO7x6KpT7sJYrTe7fxEFvDLA1Yl0WpjAZxw1PuHky1FODAJkVac2u3+kFaPCurS52J0cxlGZugSXC6EHDS4ViZ3CfwPFAdvUUtfAWKsjgXshWVIOO+8BHXB+wx7XVgLCLfA==
X-YMail-OSG: EDOkQ1cVM1ms6763lPiI1gS_V_mRb5xCTj6MVNAntySe7yUg7ChT11GMUETMVM1
 Qd13mLTHKcIXvGP5mvpTUZ6HYPc1Q_VncWnhvbMHeQsg3vHUv3aWYT_07rOdNkEvi.oOAGdZpdTv
 lqKnBTv8dkhbJCnEZb0PEU9FfEo4aSSk1RueYR.HRC2HFZplUyugaNl1Km2LAKn7v_S0MFP.jjXg
 si1yR2imQiMvAC6GyGgM5HnrVvclYqrHyMKoLdhLn1vN_y38IAl3md1NO8IekCcmRyOGLXI5pBKW
 hw4nV1bcsUIPF2.4YlH8lYPuTrYirFMng8JqnUWAV50gWK16ShV18RQB7OaeYWimwDWTv.o2H666
 1HHkGGoIFVvrke14difhCRKj6EYQgh3tnSRXIj25fvRbycatwQnLAUL4zIp2UO0W917RPpge7TYC
 eJxg_o9bnuUksI_LDCQIGlBaQGl0SGE8TfAHEwgKapVR1W_8E92mcSobYVYXflBGn7gejjcsY7id
 mVGzHrB2u2XEbJMDPZE7KFn_QB3Vnk2jIzJuDgNIJB_H79nBPRyTHtTosQEOQEJ2Ut.IcPKi5D9x
 mINuI1szBpzTPFS1RJbz7i_wJUo8JSojILAMIwNZw1qdHOkBnjeDguhz.C.6mOS68K7K6XnnYG1R
 Ts_DfXZOZYPX1RNJsjXc2ZZynmPPXY.FdqW3lq4655J5eOMHSIE0_L6aemCz5_jVP693jgAjzCdc
 ZV7b6pP_nLYiQGAxlKHdlPVOOCZyxewEQ.mkFrLK88Lktq100vBKzpOdXBubmeEhxmbIa.5bpR8_
 Ffar.zdTPPn_6Cg6LKv7HkaJvLHYUHUE8hxxneGfUewsuOts.Q35IxPUhLRUqbGQubfvofSySGGd
 xpFFRkGPbwleauYkkSfa8HHw1sAMX0liymUTA.qIxD4xYf4zrm9W339sW4QrbC_PxFDc9NKWzCRb
 VlXOjLhVgrq1URv5DlhgF1bUetnSYxf7gx8AkUQD9jqFtEEf0hwWgLJFIkZBQNKNs64635MON0HO
 q2KROUhqL88l2ALm3xvbqq8tA2ZZ7WgpdSybm08s1AJvZC8sX4IhJQR.TbkG_jLKPwPipw.4EShv
 1svO_Y.kuJbCu8JNiz_rZPbceFYAtPOZgDd5sbsorqJiGF3IWMdeJpq6nWfNm5ZkWfuBHxEt5N8O
 Dopan.iKTo1UOCoJLil9pzbIUPuCwGjpPXHbhZ0zjuVxWMKWNm7FZKjVUzlS0LoXwrdd_uZfqdLh
 Qg84.BpG3Mr04SOXIySRE.qFWhRXg_x5nXbJ0ykJU8_qP_HhH3Mo5PDj9Efzjwl4fc6Vq3sI-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Wed, 5 Feb 2020 07:55:39 +0000
Date:   Wed, 5 Feb 2020 07:55:34 +0000 (UTC)
From:   Lisa Williams <ah1195485@gmail.com>
Reply-To: lisawilliams00357@yahoo.com
Message-ID: <1407876975.669191.1580889334599@mail.yahoo.com>
Subject:  Hello
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1407876975.669191.1580889334599.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15158 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hi Dear,

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us

Yours
Lisa
