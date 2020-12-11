Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD02F4AE8
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbhAMMCu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 13 Jan 2021 07:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbhAMMCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:02:49 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB82C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:02:09 -0800 (PST)
Received: from p5b3ab797.dip0.t-ipconnect.de ([91.58.183.151] helo=sysmoGS9.lan)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1kzeqa-0001gj-7t; Wed, 13 Jan 2021 13:02:02 +0100
Date:   Fri, 11 Dec 2020 09:41:53 +0100
In-Reply-To: <20201211065657.67989-1-pbshelar@fb.com>
References: <20201211065657.67989-1-pbshelar@fb.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH net-next] GTP: add support for flow based tunneling API
To:     Pravin B Shelar <pbshelar@fb.com>, netdev@vger.kernel.org,
        pablo@netfilter.org
CC:     pravin.ovn@gmail.com
From:   Harald Welte <laforge@gnumonks.org>
Message-ID: <4812EF13-6C92-4C59-9EEA-9BE8B28CC878@gnumonks.org>
X-Spam-Score: 0.5 (/)
X-Spam-Report: SpamASsassin versoin 3.4.2 on ganesha.gnumonks.org summary:
 Content analysis details:   (0.5 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  3.4 DATE_IN_PAST_96_XX     Date: is 96 hours or more before Received:
                             date
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patch.

Can you please point me to any open source user space program that can be used to validate/verify this feature?

-- 
Sent from a mobile device. Please excuse my brevity.
