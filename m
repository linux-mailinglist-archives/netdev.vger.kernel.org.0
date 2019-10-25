Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6C6E46EB
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438393AbfJYJSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:18:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44446 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfJYJSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:18:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so1412685wro.11
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 02:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vuf33ua9lmBy/pvF4TQMMkf4uhiAiiufvhJM7ldxd14=;
        b=nPfqDeUQakScQa3qQdVWQlWdrGBkrUpwtljmckUp8qUIfIuEX/q803C8AqTUOe86aR
         pZ9IcoRNc9a8qATV5h/rQ8jchLlCJiZ6mbXhr4iRinYlmzbRFb0pbgFbqebImqzo5QMT
         YMWL57Y03bD997nLFiy2nkxK1glwLXHY0PHb77fkYxYHrZ9GU6bTLg2ZF4GLKYAYi0Nw
         OhDMbIY6tSVpAUxkqOtPDjiQvrphwNaSXNzWATpQ3M2BXuq5mBJ4N+gfQM9UH/Z/fMhF
         l98MpT6xb3X/WrPgmXWEeWkNcJKFW2n+l9vaDUiOHdXzGem6g6QMay3gZDag2POVaPPA
         D75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vuf33ua9lmBy/pvF4TQMMkf4uhiAiiufvhJM7ldxd14=;
        b=aKj494V2BQRvdgGu1UkXDnLq1IyYH63eMwJEAkbjA5NgECHvlekxTQyQSi91km7t7G
         9f8dhgx12Vl3XhY/ZA4fwGPki8E5Gpf/tXHHTDvMiXCbHOC0nnzb+sFN5wFY7xbUg5ZO
         ZkQBr/+zw+O/MOGyiavTWoBaA685Rtv8wzspljJrbOJwh5t3ePFHBkydyPlDw+wixrsd
         VUkuNZayt8FWupXSfx4KwlVkH/MxTsmelzLswCG7JBkWkfJ0ofxR6n/AGpOWVFXJPx00
         /ayhVumos6PmL0aUwS0KoRx0gkDVyyKQk3iZsr9Aoj2OZpolHKv23OTO/JpbBWziTZuV
         czVQ==
X-Gm-Message-State: APjAAAX7MebTI9Z5R1RSGrm1dqUB0op0NmJtfEcWLQl0LumM1UeCHcxF
        /vXfe8W5Yo7oXMqWY9njP2NOOg==
X-Google-Smtp-Source: APXvYqzd7ql7Px54NVr+8eWYz43YBHQLPqYq9+lilBnGAOqMC9fm4sB2otMmO9RcMc7Rk9L5Dyp0iQ==
X-Received: by 2002:adf:fec7:: with SMTP id q7mr2029985wrs.267.1571995080412;
        Fri, 25 Oct 2019 02:18:00 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id d11sm1781951wrf.80.2019.10.25.02.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 02:18:00 -0700 (PDT)
Date:   Fri, 25 Oct 2019 11:17:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     jiri@mellanox.com, idosch@mellanox.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: spectrum_buffers: remove unneeded
 semicolon
Message-ID: <20191025091759.GC2356@nanopsycho>
References: <20191025090948.13668-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025090948.13668-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 25, 2019 at 11:09:48AM CEST, yuehaibing@huawei.com wrote:
>Remove excess semicolon after closing parenthesis.
>
>Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
