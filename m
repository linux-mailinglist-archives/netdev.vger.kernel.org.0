Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5991B197606
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgC3HyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:54:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:50076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbgC3HyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:54:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8CB09ACA2;
        Mon, 30 Mar 2020 07:54:08 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3AAC9E0FC6; Mon, 30 Mar 2020 09:54:08 +0200 (CEST)
Date:   Mon, 30 Mar 2020 09:54:08 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] netlink: show netlink error even without extack
Message-ID: <20200330075408.GM31519@unicorn.suse.cz>
References: <20200330073305.CC634E0FC6@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330073305.CC634E0FC6@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the resend, I sent the first from wrong machine and thought it
was rejected because of that; as it shows, it was only greylisted.

The two mails differ only in SMTP headers.

Michal
