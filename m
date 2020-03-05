Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C053A17A236
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 10:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgCEJ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 04:26:28 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44173 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCEJ02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 04:26:28 -0500
Received: by mail-wr1-f65.google.com with SMTP id n7so6039408wrt.11
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 01:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rkhBjpoz2S/kiNqlYODOBI6TNefjZEQYY8k2EwKQ9Ic=;
        b=Akirx4eaJe4E+H50+xfVbUSaTyhZIa4n8ia+u62GMALYs0FJ85ZKDZPHeR0Ze/25g9
         warikoW5m7I2OgjrdBGrGDRbBelPIXNq8swHQb7PXFR8Cccgu2S82pFWpYF+xBz7/8QS
         84e6pZrIkvZiZFWcCWbmw4F+z222wwQ1QafCmY3higkT+QAJdJDhZAhn/57YLV53R8HJ
         KO+YuirBmFk6952Pvs5x/xEsAWlycA5j4lAvEW82NSwIhulk/sE94zDfL3bhaTTCalwl
         WsF3XiAbWtKIWS803Q3GHFQRMGnRBX9rWltF2JdPlzr9zy6isv+9KA+nnEsIGVPW7nSr
         2Jlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rkhBjpoz2S/kiNqlYODOBI6TNefjZEQYY8k2EwKQ9Ic=;
        b=N/oG+NkTc/Mp2whbhRG9kVujkcoKnBh5TYDw5CJIeYCEajcJIfUybWbB6BzxKe15zc
         Fz56u1gZJSnTtkA/fV0/FQjPADV/30Kjr2jnbzl//dFi/jC37Va4S+yk+cRsg29Ix8TX
         c0WEVPwqmBOsr2uuPDOM3+lNMImUF+WR1AjUf6PhpnGF2c/3FbKUeyPEYj4XREqbTdbl
         aZky2aoWkzROghZ7vhNYv2apq4C0dOMlHnoQkgbjWMauRj+8RLFSNZxWc2bcEb7skznK
         W00TEgARj1R7aQMARYNONO8AXiUPQkooJ34ViUWFikgGnxWhgBCzouyqn/yhiKcUtUXu
         4rFQ==
X-Gm-Message-State: ANhLgQ25oohr7OjgGzZdXBv21px2qibVbTtM6Eoun+ORGqx38+e5/3GM
        k2zAr8BQ/mm2txvr/5QShyRPaw==
X-Google-Smtp-Source: ADFU+vvHgcIqztJd+EazsB6H6ndfBy2oBAAjiVnUfP+d4rh0fKxe3RtgMcgomx78i5TLmpYNrtzjgA==
X-Received: by 2002:adf:fdc2:: with SMTP id i2mr9617484wrs.166.1583400385046;
        Thu, 05 Mar 2020 01:26:25 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id j205sm8355540wma.42.2020.03.05.01.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 01:26:24 -0800 (PST)
Date:   Thu, 5 Mar 2020 10:26:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, petrm@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/5] mlxsw: spectrum_qdisc: Introduce struct
 mlxsw_sp_qdisc_state
Message-ID: <20200305092622.GB2190@nanopsycho>
References: <20200305071644.117264-1-idosch@idosch.org>
 <20200305071644.117264-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305071644.117264-3-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 05, 2020 at 08:16:41AM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>In order to have a tidy structure where to put information related to Qdisc
>offloads, introduce a new structure. Move there the two existing pieces of
>data: root_qdisc and tclass_qdiscs. Embed them directly, because there's no
>reason to go through pointer anymore. Convert users, update init/fini
>functions.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
