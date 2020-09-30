Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA33327E59F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 11:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgI3Jty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 05:49:54 -0400
Received: from correo.us.es ([193.147.175.20]:58268 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbgI3Jtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 05:49:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0C97F11ADC2
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 11:49:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2EB4DA78C
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 11:49:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3743DA793; Wed, 30 Sep 2020 11:49:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0254DA72F;
        Wed, 30 Sep 2020 11:49:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 30 Sep 2020 11:49:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A360342EF9E0;
        Wed, 30 Sep 2020 11:49:47 +0200 (CEST)
Date:   Wed, 30 Sep 2020 11:49:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 nf] selftests: netfilter: add time counter check
Message-ID: <20200930094947.GA8199@salvia>
References: <20200924101733.11479-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200924101733.11479-1-fabf@skynet.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 12:17:33PM +0200, Fabian Frederick wrote:
> Check packets are correctly placed in current year.
> Also do a NULL check for another one.

Applied.
