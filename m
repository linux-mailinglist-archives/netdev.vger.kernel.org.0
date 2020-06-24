Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A3E20706A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389919AbgFXJvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:51:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:47468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389015AbgFXJvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 05:51:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31B0DAD25;
        Wed, 24 Jun 2020 09:51:43 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E4542602CF; Wed, 24 Jun 2020 11:51:42 +0200 (CEST)
Date:   Wed, 24 Jun 2020 11:51:42 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2 0/5] Eliminate the term slave in iproute2
Message-ID: <20200624095142.zete44mbrtieepju@lion.mk-sys.cz>
References: <20200623235307.9216-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623235307.9216-1-stephen@networkplumber.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 04:53:02PM -0700, Stephen Hemminger wrote:
> These patches remove the term slave from the iproute2 visible
> command line, documentation, and variable naming.
> 
> This needs doing despite the fact it will cause cosmetic
> changes to visible outputs.

AFAICS, your patches don't only change output of the command, they also
change command line parsing so that they break backward compatibility
and break existing scripts and tools. This is a very bad idea.

If you really want to go through this exercise - and I don't agree with
the "needs doing" claim - you definitely should preserve existing
keywords as aliases.

Michal
