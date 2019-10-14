Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B7AD6B72
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbfJNWEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:04:06 -0400
Received: from correo.us.es ([193.147.175.20]:34294 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730859AbfJNWEG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 18:04:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1334C1694AD
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:04:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06B5CB8001
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:04:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E23A5B7FFB; Tue, 15 Oct 2019 00:04:01 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE3DBDA72F;
        Tue, 15 Oct 2019 00:03:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 00:03:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A99BA426CCBA;
        Tue, 15 Oct 2019 00:03:59 +0200 (CEST)
Date:   Tue, 15 Oct 2019 00:04:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: Re: [PATCH net-next,v4 0/4] flow_offload: update mangle action
 representation
Message-ID: <20191014220401.gvcgymqqjq74ea5j@salvia>
References: <20191014220027.7500-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014220027.7500-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 12:00:23AM +0200, Pablo Neira Ayuso wrote:
> This patch updates the mangle action representation:
[...]

Scratch this patchset, it is garbled. Sorry about this.
