Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE86B28EFE1
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 12:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbgJOKKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 06:10:38 -0400
Received: from sonic311-30.consmr.mail.ir2.yahoo.com ([77.238.176.162]:39377
        "EHLO sonic311-30.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731061AbgJOKKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 06:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602756636; bh=k6qD474V9VtXKDobcCBmjOJywgarZvgPlTt0r+34qBY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=kc4GuFYOVc16vDJCvdNAdDS2Aus1qJA+e6IZmu6+83PFRJT9hZDF44CoJr9/k9ZPW9nsrD1ZetHa9ecaj1sBmPVk+nZ8XCCxXy0ZUS40YtE9MwQP6EKp8EbTOUh7wiT9A62OKaaqeq5C+wuOcEDiUFoHiQpiqcpaWuUoEE4Bxfb36Llj6JRdcHWkNCEctBlxi8PvAwOz74xYVKTDl+kJxscRTy+24trn6nvmjv6YSes5pKBR5BnVBouCOjjFKzBjgfTJSV31D2P1wX/J4MOnmtNWEtav4SFGLfrtp7ERLjHzJLO/p+iZxaEf4qJbKk8usRcYixOrouAYDc/RXFH/bw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602756636; bh=sugumTkjXZYylASI6y/gUETQfsdNSItwaIPx1OquoGw=; h=Date:From:Subject; b=hPvYBqjGuPnZ5Xka5POZtYfhTaXU2JJ6ymZvzFSQjlavBotuUcluBt5Z21BpWf99a/CcVP9Vu+QRBeao3kSVIfc6F8ylHh3tr6alv3etbezIzHcjfIxizYWjLUthi++5EkMVd06E7nw+6Rrj/di5GZGODK31GaC6PiiEiitnNdJFqNrqUasdqMxtAj+egeRMcx/3XI7ZygVt1z4hpGn+h9ZfxQjzC6C21K4mL8u+PcHaoMc5Fb8QyrJkXUGQDljw2c3Y6P/sxLWcuOs5CmE2TM1iHegKa79yXlUJVnmTV0dMXkvc9qH1STPIOL2ctMy4BXaomg5U9cXrSXow0W07fg==
X-YMail-OSG: jCPkz0EVM1mzEH_pR73_GcYP5K9d8jfuYDrhNIM416tgwvRCKzXq01x_WpIddb1
 rWmBD4ZWoKMuy4T9p0MMkbt0SCjbAnGgB8LybfziQwh3EUC7.DepVQOQXoOpPQ0QVx4lF.2NllsT
 jFUd_Ikw8P8pSEg2eQs.btpW5y67ZhHHOdK3OXVQYdic3qc4G5ApY_wHUOa3LJXfAY.jwwd9Z_QS
 udqYXetpl.LrfY0f4zLh1h1pqJmLVYhYdP8v.P.RSHvECwXV.4xVBRe2A9mBpd5UqXoWjIYS7ihO
 TMzDFN0EsCizxfejq22cY6lHn.uyyGTBUPddyNBU.n1q330te0.s1opnYXuX699RvD8KHaxpiKFK
 csRehwHGdAnytZ4rzUV66d8yQHEFrgKg1vjQuPNq7JJ8rDU2cPQnmdVak7pq6K.IQmVnSDX21DwB
 1zhKaw.F3Xqz9iIY.dSIKFQYtxQcAkLtfX9h_WTIxa1n9bRZ_80RID7opk7l5MF8XYenO.hocEtp
 jyDbukYWlh0AymikWXC1m1nbS9rtxnHmLci9V1d58.dorQpCyft669sa9aBqp6YwKRvoYgTlb_D_
 LGpSiXDTEj3Ief50J.eF2moTE77nl2ue1Df0v0dW0LkHCDRARkBWjSR0OmUDs1pB5s_mgE0jvTsc
 fE842SJ_eTXcLd.GoF6C8iwWtzS32PXj.bVc0hRBI3j2FMn_ct4e9b.Dk3rc9BNiT641hVihxwAn
 q7n0kY6rBIhTWildxuNg_uzzwHnU9ei_uTaWfpf5qBtRwHLXeF145SWgFBvQf1CRa8IR99IpfW1b
 vhL.Wf6mngZ29HH9HlykFN4CSkhJN7i6xlmXop1ZViFyZ9M3QwJyL4fdcCgDrvVROoM2D8E9ynvm
 IuOF24KpTlOzCzq_hTb.DdW.QXNOsk.AGQ.ynvS5TGvFFtGBnYKa6OUWiVBbSM6k8h8qroYPaeD7
 WagFHCjipCyNFXQkyS.Y6gqLPQ0eTTVVT8teq857HcMly0m8RCzN..CyBfRZv3hUnSXSoNzMdQcf
 zUXfcm0mLHsGnNBcG.TDHoi7sGp6zqio5H2mIkN7y.kgYPDPwVu0jNH_aGUisnFedj5LEA35xHQd
 o0nWTm2aGT5H1AFyBoNaa.s10YZJ0oAZsBJTH7gcbbq2IQKpWtiRON02imqxDLvqMoFXZm3KSQfa
 J88CKL84o91jYe_evl7s3foF1lD.37FowfOYzFUv1XgyzYyxW4X5if91h2N6uexUI1UJ9eXJplZz
 O0BPeleSctrSWyVw5H79NfuSzo_G2Y6vvcD615gopTNhOHv7I3GKPhsKopFmro2NeAec.4hC93kB
 xH6YJsRjqMYliphOy5NX1.nEULFoU7Olo_lByNqJpSak35sCgoTwoybq75Dkguc_0b8m2iM5IJ37
 _VMA9soVhXsc1udakKlPQWCRSokrwi1Em93bTHajqSA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ir2.yahoo.com with HTTP; Thu, 15 Oct 2020 10:10:36 +0000
Date:   Thu, 15 Oct 2020 10:10:34 +0000 (UTC)
From:   MONICA BROWN <monicabrown4098@gmail.com>
Reply-To: monicabrown4098@gmail.com
Message-ID: <1259086596.1583298.1602756634426@mail.yahoo.com>
Subject: FROM SERGEANT MONICA BROWN
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1259086596.1583298.1602756634426.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16845 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Sergeant Monica Brown, originally from Lake Jackson Texas. I have 
personally conducted a special research on the internet and came across 
your information. I am writing you this mail from US Military Base Kabul 
Afghanistan. I have a secured business proposal for you. If you are 
interested in my private email (monicabrown4098@gmail.com), please contact me 
immediately for more information.
Thank you.







