Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832E81C101B
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgEAI7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgEAI7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:59:31 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093B5C035495
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:59:31 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i10so10752794wrv.10
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v+Fu4L+j2MwtsSXHtFyGQ7f5pFoLvinacfVDJeR1lpE=;
        b=Jc0dPWPNu1z8a0Q+Yfdd6rBBzUbNb5sQ9CTd6sDqEGaWs8P/HOBBK0ujCSC3vkwu3q
         hXV7mH6nclWtUR9M+Z+ITbkulZpwtoXSrgHGZwaqVd7lJXPe6c1UjzvL/0iDqE98IJDb
         jL24eXz7QTL7zmqJSfxn5hpq42lqwIutCRV0ICLb2cygSGz6Iyr7R/pjvTkpAHL+zfX4
         oOYyLOMjduHL2Mo2cZYtMhtJg2nyL9PX7vOB3qojZE8PJGaHKvSuo3nWEP1UtTzuQMBg
         bY8U5ORJHZ/SGZeaUcLwU/BvOqQq4CRYlJbMnkYlABwiNSN578P3t5ZM0sdPSImI+S6F
         sTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v+Fu4L+j2MwtsSXHtFyGQ7f5pFoLvinacfVDJeR1lpE=;
        b=NtAXdwXB44vs8IaOQeiIDmG1bndi8RdJB+yB6P5TS5RCgx09RX2e+jFveu+muageBJ
         p+fDPwOa2Cp2HuUkh4JF2YikgO+Msf6lGkXs0DH3F2W/omQF8XOXrXyavvZB4G/o/mET
         hFGnKmF+HihOAVVetp7ykegSPd/BixnHqUx4BMJmKB42H8Tup/TutFEYyvjjYR2NPAuM
         vQl+YJKom7WBZrJVK/NJWOUs6JEVRGa3IfyZXvYWsUKSyuHEjIl9Ew4VbsAwiazvP0Jr
         9sBG2BITa7VMdJHcwcew8kqOLQYrEWzavQoQ6E1PfxLTSiv/qGX9QfDHKZFpIlgYQIWY
         KalQ==
X-Gm-Message-State: AGi0PuYNZn7/U6tgz5mCwRCMP1sNYplfy+hsDdj+sTh9NJBnjMvqMdJB
        oXTw9y7xZG/IUf9keGyYgE6HBzoK218k+g==
X-Google-Smtp-Source: APiQypJIVy2uoCIO/ct6n11wSDtzhikCLIUHVG/JfDDgOA+DBPN2WlOxlBSrk2thjSArvpzlknNZ7A==
X-Received: by 2002:adf:8441:: with SMTP id 59mr3243771wrf.237.1588323569456;
        Fri, 01 May 2020 01:59:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 5sm2991848wmg.34.2020.05.01.01.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:59:28 -0700 (PDT)
Date:   Fri, 1 May 2020 10:59:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v3 3/3] docs: devlink: clarify the scope of
 snapshot id
Message-ID: <20200501085928.GI6581@nanopsycho.orion>
References: <20200430175759.1301789-1-kuba@kernel.org>
 <20200430175759.1301789-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430175759.1301789-4-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Apr 30, 2020 at 07:57:58PM CEST, kuba@kernel.org wrote:
>In past discussions Jiri explained snapshot ids are cross-region.
>Explain this in the docs.
>
>v3: new patch
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
