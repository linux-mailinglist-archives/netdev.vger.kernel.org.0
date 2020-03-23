Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABC318FB72
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgCWR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbgCWR1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 13:27:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BB6E20719;
        Mon, 23 Mar 2020 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584984455;
        bh=0pOorStPdROvju7cv5wMvrCyqpvTQ7UFQ+39CdDE420=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hYc8jxNQir+LLR5KVB5qeiJYWPeFjPsz6gcGMtyYmIvw2BlNhZhrH5CLVOW/edn7u
         Ru9bH0ES8CrDA71o7qRbhLXCmmskdKsQgsscfoBpECL7SOrpFlz7QKSCFKbR1EIDIu
         pPn79GS3Vrr4sAi+d5x4wTklqGUXwF2zzDM6PJGk=
Date:   Mon, 23 Mar 2020 10:27:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] bnxt_en: Bug fixes.
Message-ID: <20200323102733.6b3dee5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
References: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Mar 2020 16:40:00 -0400 Michael Chan wrote:
> 5 bug fix patches covering an indexing bug for priority counters, memory
> leak when retrieving DCB ETS settings, error path return code, proper
> disabling of PCI before freeing context memory, and proper ring accounting
> in error path.
> 
> Please also apply these to -stable.  Thanks.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
