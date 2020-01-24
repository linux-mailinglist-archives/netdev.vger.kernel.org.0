Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72AE614880D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390112AbgAXO01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:26:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34884 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389922AbgAXO0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 09:26:24 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so2209238wro.2
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 06:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BnZjIIvKaXICAHgm0VY7qyY+9Va/Nq8cYpe2P1E7G7M=;
        b=hJHTN0jBIGxbyS81SlrfTBoyTT+wZAuQcQzwyuAkycsXBqGRh8DB5aLKD2B1YY1MA6
         D+vZw3uy/Uo15np5vNGYsQnR/178qxgeGiIHHl3P8Qtc440+u+aa4CrtuiWcx4LaBdUt
         CiGgLt9b7XtVjowgAI9wywQqZn9wAwpeDesW9wQDvcQBsXiQIWXPjlg0K6t7te/UiQKB
         LKesgIxAId7TC6hwUjLK+sws8T+fgrmFLorWOa7qECResgeFygnC3DAx1Po/9s+bwwZS
         aVSp0Jf2guRr8BesYfUad4Pg3UhVww68f0YBh6kkYIVzSpCM+Z5XlJeMfGeiOldWc/GX
         872Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BnZjIIvKaXICAHgm0VY7qyY+9Va/Nq8cYpe2P1E7G7M=;
        b=dhF1lqctrRzZWASsQzFHEB/mXUR6592vCVeoFCR1rys6o7tTIvyd375uwQAlXe6pa5
         vM71pl5bifs0d1xTpKnFy8/SUIiVeLC0zdPCSbmMwheS5yD00l7+s8HGxRGC9+DRoDQf
         48D69BsPbm/dhBzekL0tAEn779he3FVTaym/TM1W0doBueMuE+W05phxcHaz2KwOo08u
         eZ/dT+01ArwTifYqkyguCLfXbboWukXKzndORId+IPfhp8bjcc4PLqS8mQq9XOaP4oYH
         DG1Sf7tqwV5cFpARGgyCo0u4NMuJboJee5fSuMr9PE6wLYj3kwsQAy1KZZMtVjkKnx5p
         rUSQ==
X-Gm-Message-State: APjAAAVAt9iSwVd6yaX+OYrn8yMsBSSPbbfdrqkgG4Mcs9sdZzpRmBQ4
        K1irxNfmEzJK5CZRSrd+W/Cv8A==
X-Google-Smtp-Source: APXvYqyavfSM/SVJFUAAjMsCnHqOJa4dUF7X9JlJkKhBgHH6HBwSKdPedMBAclkRUlMNUGEkRdZ2xQ==
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr4693240wrm.241.1579875982846;
        Fri, 24 Jan 2020 06:26:22 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u14sm7162549wrm.51.2020.01.24.06.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 06:26:22 -0800 (PST)
Date:   Fri, 24 Jan 2020 15:26:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 04/14] mlxsw: spectrum_qdisc: Add
 mlxsw_sp_qdisc_get_class_stats()
Message-ID: <20200124142621.GB2254@nanopsycho.orion>
References: <20200124132318.712354-1-idosch@idosch.org>
 <20200124132318.712354-5-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124132318.712354-5-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 24, 2020 at 02:23:08PM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>Add a wrapper around mlxsw_sp_qdisc_collect_tc_stats() and
>mlxsw_sp_qdisc_update_stats() for the simple case of doing both in one go:
>mlxsw_sp_qdisc_get_class_stats(). Dispatch to that function from
>mlxsw_sp_qdisc_get_red_stats(). This new function will be useful for other
>leaf Qdiscs as well.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
