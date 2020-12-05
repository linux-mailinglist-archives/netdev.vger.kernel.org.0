Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C749F2CFF69
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgLEV6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgLEV6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:58:14 -0500
Date:   Sat, 5 Dec 2020 13:57:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607205453;
        bh=KhrLPKBqa+TnPlTEzjiANI5RA36EXAKB0BwD6nBzCuI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vtystkw8z694Ze/eublmMvRWhmYyjy4pJW7VYZnt8HjZu1T+eMHn66d2aClP8nbKX
         BTEoqOl5CoQyAEPJTVg21wjoNirGyXDE1Wzp1y18Z3ZKbv9ZRbdhpf+u3FYl1MrKut
         lXB5d1sEtA1QEWqn+tuo79ucj5AAmhJveCCsZqoQi+LdIHLkYA/pXdTDSz+JepWhOU
         d3DgL2LE8UcV7N4dGs4bjU2TA5cLrjOMeweZav6O9v9XeT6Y9bN3MQsLe5nbVMN4fI
         aM53c09X1rr4WInoa6EYlrtiVh+CsXGwIqoreY6brFNH7a7muC3lcm/ndT9ZzklfXM
         Ktg0qAPcX0T7A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/1 v3 net-next] ptp: Add clock driver for the
 OpenCompute TimeCard.
Message-ID: <20201205135732.2b01214f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204134011.GB26030@hoboy.vegasvil.org>
References: <20201204035128.2219252-1-jonathan.lemon@gmail.com>
        <20201204035128.2219252-2-jonathan.lemon@gmail.com>
        <20201204134011.GB26030@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 05:40:11 -0800 Richard Cochran wrote:
> On Thu, Dec 03, 2020 at 07:51:28PM -0800, Jonathan Lemon wrote:
> > The OpenCompute time card is an atomic clock along with
> > a GPS receiver that provides a Grandmaster clock source
> > for a PTP enabled network.
> > 
> > More information is available at http://www.timingcard.com/
> > 
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>  
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied, thanks!
