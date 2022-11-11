Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F5162501B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 03:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiKKCX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 21:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiKKCXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 21:23:55 -0500
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77471A04E;
        Thu, 10 Nov 2022 18:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1668133429;
        bh=7iJKokxuUjBIOn6wbzdHXufK/C8oDwn9NjLD/zCCRRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=TYOKaEkcvUweNWpJAXwEwm9PaCn0atDPNNPVzO0Fpgsh1Eh2mm3G9VrglrX3wBCiC
         +3rofAnkJrIIr9T49W5bSeFprNGP2HhFA2QaPFcKNlxN8J78DVRoVEknCaU+5hSZpW
         jW/JmNHEbwX/pe+05L/8isCcKEq4UvUUQ1zk+5sQ=
Received: from localhost.localdomain ([111.199.191.46])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 5EE088D2; Fri, 11 Nov 2022 10:23:46 +0800
X-QQ-mid: xmsmtpt1668133426tuae2lc93
Message-ID: <tencent_9BC988B1066D426A591B97A02A43AF1EA308@qq.com>
X-QQ-XMAILINFO: OZsapEVPoiO6i2VupZGcD9JwYl8dwgYlrh0QadPdjMF/2Zq++q94mkvr0ruGmU
         u9bgFg8nCxgr7bIlyH0ba9wn5MM5GwB+i7LbbIB/iJVgkRt5CW6nj6+5JGVlOzqVonvh10p0Bb+f
         eJJeoE58rKvua2uduASufeo2AK1mkCqZkmXs8cASXvweDHFY0aZgFzQK25AejG8kTXtM0l9A7xrs
         px47JvF1enw5Y6abjaDWgHK/sGZ8FtS/U5lY7QPyVDum6KgXpJWT2W7FDy1wGIMKYmtKWtuXn3cs
         uv7d1WHYrMKoq7C/yYZeYcTqEOe6hKj0NFRDc/FqA9s3Ict870KK90+MxNwTrxGDPPAq7pDzMNtr
         nNEFpZpNAEmIRXOp1m5MeIwTZcN/5wQY+J7KGJEk6cUUg4mGbNN9I3qQosEBXs8tzAeXaurZWw5D
         SvfLJpBtb0FshsK/eHQ0Vs9XzTrcau9rv+BhKKd/H/smdmSBGAorwFXipSLIZKe3JWq5FCrvf4O1
         Czy/q88elA1G8vIwEIAtssxtDZBpqDQgsMifMJhvkX/L7TuBF58rN1yLEQIuRkHJeZoM6PwM5nxD
         g5GwxE57DVao3RZRnI1BH2PHoYv4WbGjQqlWVrJiaZ4G2GDamPB0g+Py3V9AkMW0Tow7q/2yFgoX
         y+tMoEAyuW2bMEvSVAusziwIlBAjFl1CrDjs1KHTKa+w4Oo5SoLKy5HEUU92gQBOj1Drxg/msFVd
         yMRnrHPDFwjif8LyVbHgACudWzkNaS4F8LaEKlWmWhH50WxuTyzxr0qbu4NtFv6SoYkL+ceRVL6i
         33CyPKlM9Drbcnp2hq71QSkyFfQvFrFPD5sk1Eeql4lomKhpVX005qhWv/6X5r5pdpLwq+aPm9gc
         coBH0RxXgO0ou2S8P1nytzUCfIa6inOT9k/eLATwV81YKWsc7Fp+L8tJ+GxC22oWWpfzLzBA1HEA
         Q1cw2StnmhwBjGFuQEtVJOE06MBnv7DCvpnu7NZ+sXFbh8FcGrt+hhkn0DY4BfXgJryBXRjhg=
From:   Rong Tao <rtoax@foxmail.com>
To:     yhs@meta.com
Cc:     acme@redhat.com, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, rongtao@cestc.cn,
        rtoax@foxmail.com
Subject: The subject of the previous email error
Date:   Fri, 11 Nov 2022 10:23:45 +0800
X-OQ-MSGID: <20221111022345.13164-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <4ed2ebee-26a8-f0ab-2bc4-a0b6a29768af@meta.com>
References: <4ed2ebee-26a8-f0ab-2bc4-a0b6a29768af@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sorry, The subject of the previous email error. Please Just Ignore 

https://lore.kernel.org/lkml/tencent_754AAA6CBDDE8DB223CE1BF009D566E55E0A@qq.com/

It's not a PATCH.

