Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6069B1FEAF2
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgFRFcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:32:41 -0400
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:49946 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgFRFcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 01:32:41 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 2E0971E14;
        Thu, 18 Jun 2020 05:32:40 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:2894:2899:2904:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3870:3871:3872:4250:4321:5007:6119:6742:7576:7903:9707:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12297:12438:12740:12760:12895:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21627:30003:30012:30034:30054:30055:30064:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: offer98_5e027c126e0d
X-Filterd-Recvd-Size: 3259
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Thu, 18 Jun 2020 05:32:34 +0000 (UTC)
Message-ID: <57110139759cc77f21a150a3faed0d2584dfbe21.camel@perches.com>
Subject: Re: [net-next 02/15] iecm: Add framework set of header files
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Wed, 17 Jun 2020 22:32:33 -0700
In-Reply-To: <20200618051344.516587-3-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
         <20200618051344.516587-3-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-06-17 at 22:13 -0700, Jeff Kirsher wrote:
> From: Alice Michael <alice.michael@intel.com>
[]
> diff --git a/include/linux/net/intel/iecm_controlq_api.h b/include/linux/net/intel/iecm_controlq_api.h
[]
> +enum iecm_ctlq_err {
> +	IECM_CTLQ_RC_OK		= 0,  /* Success */

Why is it necessary to effectively duplicate the
generic error codes with different error numbers?

> +	IECM_CTLQ_RC_EPERM	= 1,  /* Operation not permitted */
> +	IECM_CTLQ_RC_ENOENT	= 2,  /* No such element */
> +	IECM_CTLQ_RC_ESRCH	= 3,  /* Bad opcode */
> +	IECM_CTLQ_RC_EINTR	= 4,  /* Operation interrupted */
> +	IECM_CTLQ_RC_EIO	= 5,  /* I/O error */
> +	IECM_CTLQ_RC_ENXIO	= 6,  /* No such resource */
> +	IECM_CTLQ_RC_E2BIG	= 7,  /* Arg too long */
> +	IECM_CTLQ_RC_EAGAIN	= 8,  /* Try again */
> +	IECM_CTLQ_RC_ENOMEM	= 9,  /* Out of memory */
> +	IECM_CTLQ_RC_EACCES	= 10, /* Permission denied */
> +	IECM_CTLQ_RC_EFAULT	= 11, /* Bad address */
> +	IECM_CTLQ_RC_EBUSY	= 12, /* Device or resource busy */
> +	IECM_CTLQ_RC_EEXIST	= 13, /* object already exists */
> +	IECM_CTLQ_RC_EINVAL	= 14, /* Invalid argument */
> +	IECM_CTLQ_RC_ENOTTY	= 15, /* Not a typewriter */
> +	IECM_CTLQ_RC_ENOSPC	= 16, /* No space left or allocation failure */
> +	IECM_CTLQ_RC_ENOSYS	= 17, /* Function not implemented */
> +	IECM_CTLQ_RC_ERANGE	= 18, /* Parameter out of range */
> +	IECM_CTLQ_RC_EFLUSHED	= 19, /* Cmd flushed due to prev cmd error */
> +	IECM_CTLQ_RC_BAD_ADDR	= 20, /* Descriptor contains a bad pointer */
> +	IECM_CTLQ_RC_EMODE	= 21, /* Op not allowed in current dev mode */
> +	IECM_CTLQ_RC_EFBIG	= 22, /* File too big */
> +	IECM_CTLQ_RC_ENOSEC	= 24, /* Missing security manifest */
> +	IECM_CTLQ_RC_EBADSIG	= 25, /* Bad RSA signature */
> +	IECM_CTLQ_RC_ESVN	= 26, /* SVN number prohibits this package */
> +	IECM_CTLQ_RC_EBADMAN	= 27, /* Manifest hash mismatch */
> +	IECM_CTLQ_RC_EBADBUF	= 28, /* Buffer hash mismatches manifest */
> +};


