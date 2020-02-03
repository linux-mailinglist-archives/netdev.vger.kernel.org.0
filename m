Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AFE150050
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 02:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgBCBps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 20:45:48 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:33757 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgBCBpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 20:45:47 -0500
Received: by mail-pl1-f170.google.com with SMTP id ay11so5200140plb.0;
        Sun, 02 Feb 2020 17:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=biDSrCR1eP28JzHxJCCOBKezgQLDm4X9uqOfHfatW2Y=;
        b=TeMIvx+iShPj2d3PyK/1BmMRWfjmaPWgS8OHGl+HEkJaAgYfueCeKcQUlCr6qzjScs
         qjdKhZCu3EOCaKMTgTgGEFPdg/DjZbhsR9fN4GQFVORPdZ7zUSggRoANToJgJVMAVvve
         WLBF1gxMsPqbJ8qv3ojZCLN4c92x77DPw0j73Qi56mQNomezV6VD7AGrn7OZhlLXvCbR
         BJo83s0bLfAB4sKEq49ONZ/lB5Dig0QrbU675fp606k5SGKzUQVNSrhyPwoNLbDJZ2+x
         TK7aHVU3nnVeb3GLbGJ092fm/OBT/l6vTDMr81BcGkfgJl/SDxTLYSwhJXO4IVAPbbuK
         eoZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=biDSrCR1eP28JzHxJCCOBKezgQLDm4X9uqOfHfatW2Y=;
        b=JD3on5X1SB0o8MKXNbQ/z23k9ITAvOFZEBO+afEFbN4wzg7H7/1JhHGDx7DZ8+muB1
         2yfKm6fVWjrqnSHG1+lXkJmET86t84d5NzM1u6hoYxqyKrDkqzak6BXsxLFPPK5JQm11
         d7i58huoU5S0shMjhZPEFVbOkFYQanjZS0HdVgpXnfwL/hehc7lLB8VfjLh5NDk8PpiM
         DdT5ACn5NSJQ4yvJHUiq0NSWKOYFMfG7SYCNt/Ia7D6gDov7YEkFUT3s/jCkQso/IDTJ
         HY4UoT6OXn59rdYZHv6UJ/HdMx5rR3YhHP1Vd6NpG2Nprf0692UmERtZjTG5HNVOF/xT
         5JHQ==
X-Gm-Message-State: APjAAAWoTqMuFEm4CsMWGgG8G/omfDvHcS8oyj+vG8a3HEJP2QXoRz/C
        3MgVZlablYPfOvoE3b4weyY=
X-Google-Smtp-Source: APXvYqwESnZ//QQxLHVoRT+umFDYhO4Iu673FVXCH2wzZBtnqX8dC+tZ8wNJsRkbuSCFlhpC7EAMDA==
X-Received: by 2002:a17:90a:6:: with SMTP id 6mr27354639pja.71.1580694347066;
        Sun, 02 Feb 2020 17:45:47 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x25sm18440955pfp.30.2020.02.02.17.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 17:45:46 -0800 (PST)
Date:   Sun, 2 Feb 2020 17:45:44 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     christopher.s.hall@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        mingo@redhat.com, x86@kernel.org, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 1/5] drivers/ptp: Add Enhanced handling
 of reserve fields
Message-ID: <20200203014544.GA3516@localhost>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-2-christopher.s.hall@intel.com>
 <0f868a7e-5806-4976-80b5-0185a64b42a0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f868a7e-5806-4976-80b5-0185a64b42a0@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 08:54:19AM -0800, Jacob Keller wrote:
> 
> Not that it's a big deal, but I think this might read more clearly if
> this was "cmd == PTP_PIN_GETFUNC2 && check_rsv_field(pd.rsv)"

+1
