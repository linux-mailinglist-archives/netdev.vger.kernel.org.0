Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E446D17A239
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 10:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgCEJ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 04:27:03 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37318 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCEJ1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 04:27:03 -0500
Received: by mail-wr1-f67.google.com with SMTP id 6so641127wre.4
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 01:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Y81tTR3k49ACsxD1FuuI8PfOBlyeM8Jpf41fM0oR/E=;
        b=uIkNOh/q/mtkBCivWPgpYh4qDbZ/xKbBfd3ljkq3Bs4r/rMWWTwpD//i8U39PVeQfR
         RWi1cK1E0gW6UPOACMZAlQKjgHkXy3gHOSg41PW9tu5iJfYNx+k7lbBPphLSEERawgeL
         xGQEWg2Dp3O2X5hN93suT1Jo27qDKj85guDLuytbfSQ5rgkYaf44P+fnALhGjozowu1o
         ZPYbB0x+5CW5l9hafbuFW9zMJY+IK7YByW9LgCHuJCdaA0lGvXlWcNwBw644hU4qCF9B
         KFputO3OPBXypxcK1dK1LjZun7CS1gvHaT/pxcVxfupeRFH1XWsZmp4TsQBksXnGeqj0
         G2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Y81tTR3k49ACsxD1FuuI8PfOBlyeM8Jpf41fM0oR/E=;
        b=B82UUS0P2hkbBVJ9D8eCV+IhQvIfyFHPbiMOIoWsO61pXKK/JpxNAaIeenB9VbTYdF
         BqWcN4kTGTXtt7neSPDz4wykW6EspLiKPkFYFBANcPQR9M15ApTROxXNcOi1IebldYm4
         1rArONxHioQoegL1F0WdTnlIZ3Km4QSV2OdOR5aH+v97TV7f2+xc/2yYmGNa0mawRBTL
         OLU5QYENKwtmmpz0aOI/xl8HiWGo3fEAl9sVMIfPgYJBsGv2njG56EyChGDAbVlPHpKx
         b4cUevk7Bf8brv/33INrIkt5gwWM1AYphdd1QxxCtd5xguhkeVL21zsNE/+Q9oqAT9FX
         bncw==
X-Gm-Message-State: ANhLgQ32O4mlaVx5EJIJ7P8KINkI3x79BBUeyufHeQtqUtqhhTck0wDD
        RfkuAkbs05QgwNXifXVALJHgNA==
X-Google-Smtp-Source: ADFU+vtXCKwfypnXO5VGhcRC6l0WjRULjVi5reDQd+sQD39zr9/jy6Y2uHKpp2OLxqklb/OmiQAGlA==
X-Received: by 2002:a5d:658c:: with SMTP id q12mr9704232wru.57.1583400419462;
        Thu, 05 Mar 2020 01:26:59 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id e7sm24084980wrt.70.2020.03.05.01.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 01:26:59 -0800 (PST)
Date:   Thu, 5 Mar 2020 10:26:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, petrm@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 4/5] mlxsw: spectrum_qdisc: Support offloading
 of FIFO Qdisc
Message-ID: <20200305092658.GD2190@nanopsycho>
References: <20200305071644.117264-1-idosch@idosch.org>
 <20200305071644.117264-5-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305071644.117264-5-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 05, 2020 at 08:16:43AM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>There are two peculiarities about offloading FIFO:
>
>- sometimes the qdisc has an unspecified handle (it is "invisible")
>- it may be created before the qdisc that it will be a child of
>
>These features make the offload a bit more tricky. The approach chosen in
>this patch is to make note of all the FIFOs that needed to be rejected
>because their parents were not known. Later when the parent is created,
>they are offloaded
>
>FIFO is only offloaded for its counters, queue length is ignored.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
