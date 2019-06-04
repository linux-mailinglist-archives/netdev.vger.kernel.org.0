Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B9E34A63
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfFDO2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:28:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45700 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfFDO2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:28:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id w34so10443878pga.12
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 07:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xf7g+dcunb9BHC7qV5paewQDka8pa9Aq/arV6lYtUn0=;
        b=qJTPxVUSMQYUC5G5bYEqrwVwv3yUaeRypGu1J8BdmpuCdNRBAHbuKfU9GUUl744gNa
         1Rmj/tmoV1r2OJljFqaYqlXzIjQ22TTHYAdJ+fbQatAG43cHZBHjmK4xkPXZA8xlBrev
         DI/WUILnK8VNZ12Mo6YM8LFACBqjKCkezO+vCyNJA9v+9vR7gBhsAV5IdfKUDi1LrTdw
         e8nXntdky11VjEOQ27+C3qGRPLp0IM27V7Dgi5aF7Whmjz+o+Sjet9s1+TrUHmBtu2l1
         nIqKCdDm6vNhcjW8kU5Gx2BWGAeNbsm0vaG69qnjYtmkTJO33yDep+CIRCK4TdADHLww
         D13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xf7g+dcunb9BHC7qV5paewQDka8pa9Aq/arV6lYtUn0=;
        b=oZ0MLm73kNaNR3RlK1JGU8g1uV5lWE4TxsP57ZAD4I8+j5B6Fe8A0a8uIV6oTNGoU0
         oFV3NpK6Gds07HpaboF36cBhRkMyajlupvfjutRuAdPHhYGa3xxEWmgl9mjMlJ4R0aNy
         QSaKbjPp+k3u0cSKvDHwEYMyfU9TzjiIe/SkTQ1GnF/yrfaWalK3cQjXQXi+GVpokscs
         Fb4ohTr3XEoHa+sysBtaYYb6Sapbgr5x5xQ1sKluTU/DSjO2cHQ6J6z1lGJdA1rBPgJm
         pThfsho68fYD+quNSsz55cD7yP66wO9OSaIwS+99IUDjSOYAigFsHfyQlcsUlWCR7zU8
         tKAQ==
X-Gm-Message-State: APjAAAXKZYVO34Wj5SgpWmAOTaIIYHTJE8hnArCsWVF09p5440igmHrk
        M4U1p/XZP7BRdQFIeEBJ1ig5AXlV
X-Google-Smtp-Source: APXvYqwLLbisylcuLra8nHg6HiKWBi2qD5PCnX7fxiccrlrp4VcCc9oace8mIs3WbGCIt1t9pCYjqg==
X-Received: by 2002:a17:90a:21cc:: with SMTP id q70mr9738067pjc.56.1559658502048;
        Tue, 04 Jun 2019 07:28:22 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 5sm6574917pgi.28.2019.06.04.07.28.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 07:28:21 -0700 (PDT)
Date:   Tue, 4 Jun 2019 07:28:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Message-ID: <20190604142819.cml2tbkmcj2mvkpl@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603121244.3398-8-idosch@idosch.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:12:42PM +0300, Ido Schimmel wrote:

> +static int
> +mlxsw_sp1_ptp_update_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)

Six words ^^^

What is wrong with "mlxsw_phc_settime" ?

> +{
> +	struct mlxsw_core *mlxsw_core = clock->core;
> +	char mtutc_pl[MLXSW_REG_MTUTC_LEN];
> +	char mtpps_pl[MLXSW_REG_MTPPS_LEN];
> +	u64 next_sec_in_nsec, cycles;
> +	u32 next_sec;
> +	int err;
> +
> +	next_sec = nsec / NSEC_PER_SEC + 1;
> +	next_sec_in_nsec = next_sec * NSEC_PER_SEC;
> +
> +	spin_lock(&clock->lock);
> +	cycles = mlxsw_sp1_ptp_ns2cycles(&clock->tc, next_sec_in_nsec);
> +	spin_unlock(&clock->lock);
> +
> +	mlxsw_reg_mtpps_vpin_pack(mtpps_pl, cycles);
> +	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtpps), mtpps_pl);
> +	if (err)
> +		return err;
> +
> +	mlxsw_reg_mtutc_pack(mtutc_pl,
> +			     MLXSW_REG_MTUTC_OPERATION_SET_TIME_AT_NEXT_SEC,
> +			     0, next_sec);
> +	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtutc), mtutc_pl);
> +}
> +
> +static int mlxsw_sp1_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
> +{
> +	struct mlxsw_sp_ptp_clock *clock =
> +		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
> +	int neg_adj = 0;
> +	u32 diff;
> +	u64 adj;
> +	s32 ppb;
> +
> +	ppb = ptp_clock_scaled_ppm_to_ppb(scaled_ppm);

Now I see why you did this.  Nice try.

The 'scaled_ppm' has a finer resolution than ppb.  Please make use of
the finer resolution in your calculation.  It does make a difference.

> +
> +	if (ppb < 0) {
> +		neg_adj = 1;
> +		ppb = -ppb;
> +	}
> +
> +	adj = clock->nominal_c_mult;
> +	adj *= ppb;
> +	diff = div_u64(adj, NSEC_PER_SEC);
> +
> +	spin_lock(&clock->lock);
> +	timecounter_read(&clock->tc);
> +	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
> +				       clock->nominal_c_mult + diff;
> +	spin_unlock(&clock->lock);
> +
> +	return mlxsw_sp1_ptp_update_phc_adjfreq(clock, neg_adj ? -ppb : ppb);
> +}

Thanks,
Richard
