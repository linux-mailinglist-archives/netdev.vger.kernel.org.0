Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB852A6521
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgKDN2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:28:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729520AbgKDN2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 08:28:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaIpF-005D1e-Gs; Wed, 04 Nov 2020 14:27:45 +0100
Date:   Wed, 4 Nov 2020 14:27:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, Wei Liu <wei.liu@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paul Durrant <paul@xen.org>, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/12] net: xen-netback: xenbus: Demote nonconformant
 kernel-doc headers
Message-ID: <20201104132745.GZ933237@lunn.ch>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-6-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104090610.1446616-6-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 09:06:03AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/xen-netback/xenbus.c:419: warning: Function parameter or member 'dev' not described in 'frontend_changed'
>  drivers/net/xen-netback/xenbus.c:419: warning: Function parameter or member 'frontend_state' not described in 'frontend_changed'
>  drivers/net/xen-netback/xenbus.c:1001: warning: Function parameter or member 'dev' not described in 'netback_probe'
>  drivers/net/xen-netback/xenbus.c:1001: warning: Function parameter or member 'id' not described in 'netback_probe'
> 
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Paul Durrant <paul@xen.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: xen-devel@lists.xenproject.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
