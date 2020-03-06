Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0D117C63D
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 20:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCFTXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 14:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgCFTXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 14:23:33 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C88B20675;
        Fri,  6 Mar 2020 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583522613;
        bh=zxRwL6+WOGveh6aAvHrHRizsL+TZTMIELzdCHflakTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VWp/Ncdxe4dsuv3n+Sh+ShIWbChsETb8uakh61fyi3usIMTX9ijRnT+93N+IILno9
         RekefrMDYfcoZDhHlNMVKRTWJ8rtnwUnarEuOnaNq0XAKRVgtY+l1f5NVZX+Y6i/Wm
         YZr4YTFfTa7ALDEyIKKya1t7eHBKEEYekGPm1icc=
Date:   Fri, 6 Mar 2020 11:23:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 01/10] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200306112329.196440c7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306132856.6041-2-jiri@resnulli.us>
References: <20200306132856.6041-1-jiri@resnulli.us>
        <20200306132856.6041-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Mar 2020 14:28:47 +0100 Jiri Pirko wrote:
> @@ -168,6 +170,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>  
>  struct flow_action_entry {
>  	enum flow_action_id		id;
> +	u8 hw_stats_type;

nit: breaking with the funky member alignment here?

>  	action_destr			destructor;
>  	void				*destructor_priv;
>  	union {

