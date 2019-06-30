Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFBC5B1A2
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfF3Usj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:48:39 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2108 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfF3Usi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v2Kl+apw6t0/zOtn7BYTHYkuOx6VpgcQTSqOJ7XjIlw=; b=eS/B6G3nINYaImS/ZuS+WEB+AC
        /g6KH2XUOnua6fnt1kFQ30LPciV184DD3N6ZZPhVM1To3UCUvUTMIASMMWWOizz1eUcwDEJxe1vA1
        FFyaIM5K0O3ckGZFUyduPEwBv76BiNxZxq7JICOHhIUC/ldU+tPSyRsh6n89uxIuHDHo=;
Received: from [fd06:8443:81a1:74b0::212] (port=4334 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgim-0005Si-NV; Sun, 30 Jun 2019 22:46:48 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgim-0007zn-Il; Sun, 30 Jun 2019 22:46:48 +0200
Message-ID: <ff5eb3629f00f45ff9fd4aab6a78c79328b3fcbe.camel@domdv.de>
Subject: [PATCH net-next 0/3] macsec: a few cleanups in the receive path
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Sun, 30 Jun 2019 22:46:48 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset removes some unnecessary code in the receive path of the
macsec driver, and re-indents the error handling after calling
macsec_decrypt to make the post-processing clearer.

This is a combined effort of Sabrina Dubroca <sd@queasysnail.net> and me.


