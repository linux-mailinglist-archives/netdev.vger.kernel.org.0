Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF91234D
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbfEBUZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:25:50 -0400
Received: from smtp.sysclose.org ([69.164.214.230]:37212 "EHLO sysclose.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbfEBUZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 16:25:49 -0400
Received: by sysclose.org (Postfix, from userid 5001)
        id D1B346D63; Thu,  2 May 2019 20:25:47 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org D1B346D63
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1556828747;
        bh=2jnDtG7w/g8aB9dYx9V9VlOXmpn9L5ABkjigusylBFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A+N1u5eW2NqrLkuURYhl0LsijbNLkab7SBkoaI0jIlQhTfXrPXH687guAYjkgODlH
         hNMkMLcN1uXM1UOsAogYvXrJdzL45O2npxS9UQ06wb/tlt4rs4SVryjydQN9UCeEjJ
         NQPDxlkEkzQEVwbN1hbWrwqfx/75HxTSFgUdxF1KCNSiCuk/QWoYFtuJUjjRlKAQMO
         JkdKcZppbUDdbwUtMrwuH5rfYxLo2SGIwgGvMxd3YstHl7X0QP0Vo/b6/9KJkuIFaG
         UVHAO3oNeX5w90NTlswHZEW0drHPGsNZbQi4FhtRnPFo4taGY414TcXG0VmGYxLeu+
         GaotsmJ6it7ng==
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on mail.sysclose.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=5.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.0
Received: from localhost (unknown [177.183.215.2])
        by sysclose.org (Postfix) with ESMTPSA id 395896D61;
        Thu,  2 May 2019 20:25:46 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org 395896D61
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1556828746;
        bh=2jnDtG7w/g8aB9dYx9V9VlOXmpn9L5ABkjigusylBFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JNTlDcUHTYRR+9Z8Z3GlqMIj1Ink7V7VMpqfX7jSVZsi8JL1QsNWzjuBI2nj2cFXE
         3JfN2tuCh4lSKrOBv51elzMkwL2XtDF/LHPsIT7HFLI1Pt98xwAkLNGcDKQqWsIAp4
         aK+Qlr2PcfnB0n6A8HM0vNjttxZoc9ZxtfI3ZYreR3Trr/B38j74H+xOILxewVXzIv
         jwZvlVZRBxp3f/+WN3smlLO375DbF7JZLARzU2u7egc+yhCGwLvSe//mlO2BYSu6ae
         AiRGGo4EuAB4I7JPo8FiVIuC414WVK/VwnLOHc58KYQRveRQADJzd5W//x/x0IHiB7
         arFFhUNr5y++A==
Date:   Thu, 2 May 2019 17:25:43 -0300
From:   Flavio Leitner <fbl@sysclose.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net-next] net: openvswitch: return an error
 instead of doing BUG_ON()
Message-ID: <20190502202543.GC3493@p50>
References: <20190502201238.21698.58459.stgit@netdev64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502201238.21698.58459.stgit@netdev64>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 04:12:38PM -0400, Eelco Chaudron wrote:
> For all other error cases in queue_userspace_packet() the error is
> returned, so it makes sense to do the same for these two error cases.
> 
> Reported-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

LGTM
Acked-by: Flavio Leitner <fbl@sysclose.org>

