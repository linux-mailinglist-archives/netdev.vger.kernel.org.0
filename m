Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C283C1893
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhGHRp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhGHRp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:45:57 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D40EC06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 10:43:14 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id s4so6447750qkm.13
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 10:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=akExZlXfzzWeEV1vONzULN7Ly/6NeGtVmi8mRpEDmf8=;
        b=MYsablPH0SXJSuED4xm417ftbm/7N7QfvP8SikmFuMTOS2BB5V7tIpQ1YadoPJJo+0
         UPNc6MrdAuM4kSI86b1WIdJ2lNvxpn7CeNTzfsDR+tYCRq9Gi5pXebHhHZtOqEZDvdYT
         plixrbg4URQzPOwSI+IKmKHwRvRQbU3uMT57WQt2eI6l7H7eukPos8cUVyhKhRlak3WN
         KHxAYJE3CvEMnAgHjJ+dOXcLFRdgIx4yw8bHszChDe4Acck7S/DTOHxBruD3I0xEJCf3
         +ET+IomWMrjjtVF0ECd65wfY0YseV+3NcSsB4MAok4HzbVxgwGGX1HJ5oheWoFsIhxrM
         OsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=akExZlXfzzWeEV1vONzULN7Ly/6NeGtVmi8mRpEDmf8=;
        b=qaKiYP96t8I3/5AGMpxAVHncirIpfnJp/B0tY1/d5PP9+ScPpm6bPaikj/JqrWJ9QQ
         oJquOiJJrUGhbpLDjncssQFIHOoRLhK0jsArqQH+tDEjo+Odh7cd98IvhVpytxsumsfs
         jknFm1pWIwgJbaLhZie/a0RIqXuSidK0KPAhwMj9MGDcRmTBm0CjAfsRoy9xmJ40ibfW
         XnVWp4BY0306Oq13bpCpqWNgJZRRj3HXzOellxBeNvW1tWDFMdP5UVYGVSX/NcMF1eI/
         SlLxMB6aby+J3IWyOyOamDFOD+VIu8y0uWuz/KApVJ9InoUh/o8t9Jb20dV+Tgk2M7kk
         jpDQ==
X-Gm-Message-State: AOAM533nBjgd/C1qkZgIkFqStxEeSgXsQReerwOBZdAg2ZddsmooY68E
        +iZ1ti4SDdELeHIplG7/Cl5zEQ==
X-Google-Smtp-Source: ABdhPJyYsm1/iLiWMKCdcfBEnN7MW1bhFmg5WCVlAl/Wr88/YXS3yjWT/qM/xUOpH1oLO+Zfnax5iA==
X-Received: by 2002:a37:468b:: with SMTP id t133mr32258137qka.189.1625766193206;
        Thu, 08 Jul 2021 10:43:13 -0700 (PDT)
Received: from iron-maiden.localnet ([50.225.136.98])
        by smtp.gmail.com with ESMTPSA id y4sm1280556qkc.27.2021.07.08.10.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 10:43:12 -0700 (PDT)
From:   Carlos Bilbao <bilbao@vt.edu>
To:     davem@davemloft.net, Joe Perches <joe@perches.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next v2] drivers: net: Follow the indentation coding standard on printks
Date:   Thu, 08 Jul 2021 13:43:12 -0400
Message-ID: <1718548.TLkxdtWsSY@iron-maiden>
Organization: Virginia Tech
In-Reply-To: <ccf9f07a72c911652d24ceb6c6e925f834f1d338.camel@perches.com>
References: <1884900.usQuhbGJ8B@iron-maiden> <5183009.Sb9uPGUboI@iron-maiden> <ccf9f07a72c911652d24ceb6c6e925f834f1d338.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Joe,

I apologize for the mess, I will send two different patches for the drivers now.

thanks,
Carlos.



