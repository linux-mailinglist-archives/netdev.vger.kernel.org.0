Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE42135974
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 13:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgAIMrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 07:47:02 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:40259 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgAIMrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 07:47:02 -0500
Received: by mail-wr1-f51.google.com with SMTP id c14so7246435wrn.7
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 04:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UHb91H812PagwJkS3UjGEQLUs2ZiLF/pjraCvH+MVOY=;
        b=gR+TbtRWbdCmo1NzNhZA7KLf6Ohb6BEJ1fmSXZsO3qwnoGqs7vlzit1fN9Zw/D28QA
         d86GYVVsqIlUNH0qNTCMQ/NQgSrnhy9LnG5ov48FVDvODHx/L4Mv2Vbjhq4p97wJpiRQ
         /uFpBLIiNoB/i2GMdEuoFkMEVJKBpyFk8i+tmQc8g//G8g3hmauJK9sMa0q9RqurBdp0
         66m7GUIj9pwLLovImMduvfY0OW50euKKAZtn5vPvVfjF9DDtruxun8YxRkaVT1rf7Lin
         wUQVs9mG8sNQIJnVZ3Wz8H1RM8m8n5f+Ydp1JivfxC5sB8GMTVtJhIKCLDPkdz+p63WN
         OPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UHb91H812PagwJkS3UjGEQLUs2ZiLF/pjraCvH+MVOY=;
        b=ZFeiT/qVs39lwwjBQk+54ZCaJt4S5vQqV0vv79wgGiRFYE6rlXx5N8UzMOZ+dz7LYb
         Pmcj020i4eSxXbyuFoteknZ4zJUloTqFrglyr0aGyhBdm31ONJP1U56eCCJh+e9gupct
         KPQQ98Cu7JMBJ97a7hhCKZyKxQbNb/4ZAx1SyDRi+UoHSyCtJ+Rk+QmJA27AjTZm4CKk
         cnnQc48w41L0TM61KSwk4zd65Yo/Cl1sk+jeuDSMvuMojuMxCYdcYPnSBQrVWtLJz54k
         gv9/3kP9IXCH34QcBmrhqdU4xpmvxFmz+np7XqeWWPyBy2BdofrSRT1p2O3My2oViuY5
         U1CQ==
X-Gm-Message-State: APjAAAUMo8yd401MUqO+QeN4OHtsZWneoC+2jxkfveyq0Bdorh52mvZW
        uFV+f82zHoJo+gkzJGi/PZvghADopdY=
X-Google-Smtp-Source: APXvYqz4TqMlHRoAvsRTQbbpb/OcNn2dSESSyjK9JtnDrABqs8FK9t7VAF/QRXBj3Bs86MwJTKIPKg==
X-Received: by 2002:adf:df03:: with SMTP id y3mr11674574wrl.260.1578574020161;
        Thu, 09 Jan 2020 04:47:00 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id w8sm2904276wmm.0.2020.01.09.04.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 04:47:00 -0800 (PST)
Date:   Thu, 9 Jan 2020 13:46:59 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] flow_dissector: fix document for
 skb_flow_get_icmp_tci
Message-ID: <20200109124659.GC21801@netronome.com>
References: <1578531596-6369-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578531596-6369-1-git-send-email-lirongqing@baidu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 08:59:56AM +0800, Li RongQing wrote:
> using correct input parameter name to fix the below warning:
> 
> net/core/flow_dissector.c:242: warning: Function parameter or member 'thoff' not described in 'skb_flow_get_icmp_tci'
> net/core/flow_dissector.c:242: warning: Excess function parameter 'toff' description in 'skb_flow_get_icmp_tci'
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

