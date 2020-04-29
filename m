Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DBA1BD4D0
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgD2Go4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgD2Goz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:44:55 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9315CC03C1AD
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:44:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h4so674977wmb.4
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 23:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JFqUTnrinAq6nZfLoV6YuKpBnz38o+8V5VmKg0G+pr8=;
        b=aTDzAz0ti8e27lksHYqINViI+TDK5FlYTnI5o90UBqPPs1kaMzOECs+b2MDuLX1Q+F
         OHWH0/ZqkruPM7hhPcBrsgvVqwhNsjLYnyMaSJoyiPDH8/50vsc093Y8xEmgFM8wv2/2
         pBXSIyilRQktPqqwghxlIPmTh8XAxs8bTgLKrXN5TxBHoxdETwe88/QFb3ikwNxq0K7C
         jKGDwl4E7XIEjdmjzyIOKfsyqEevrw4JWi4frnd9V3CtL/+Mon6kByYRd+yvy334ccmS
         njzIkhiPkDdCH7WzCwwUTCdYHmDqcRnxQeusw4DSprLCE0oEljr1gULChZuSczbDcu0D
         83FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JFqUTnrinAq6nZfLoV6YuKpBnz38o+8V5VmKg0G+pr8=;
        b=awjTo74jNlhFrjyf35UwC7AVDorwzLCgSSqLWnQsG831mM6rHuff7JUMQHM+jBeDNK
         Gxjfn0o3qmio6NfaIaLOM1CJAGPe3YN1zLPil0cnFTzdqRQbwtz/NgAWOciD1Tq0xz5I
         HvMRDemDAoc7NmBqmcvzps/QLVvQyOxskjNyP+nIb+NjtCZ+xj1rTjyJiCYdXHeTtU7m
         WsPUP26KVBmR8qMLgcWGiyODz9E8H2JFp6sIqaHhRLx+wgIBv0UWzFVkuuuP41ehuxHY
         pnV4+fZ9nN0dccLPBXy3OZJH3LmkoW1KX8qG71qfZmWadUfSvhULlrw2XWmbrv+Z1i14
         wwFA==
X-Gm-Message-State: AGi0PuYO5XlofUIbfRE7d+PPKYsQmpGU8JdPsKbqn69s0yD5FqQDlTfO
        MqjwNpuhElBebQ1oSg0L0Bbtrg==
X-Google-Smtp-Source: APiQypKEjFFMcP/lKdFtE4ah08auUCe53Kif36p16iNj4YnNisSp3H/IJktuD0F5yiiZsPc7PQoRLQ==
X-Received: by 2002:a7b:c247:: with SMTP id b7mr1426332wmj.35.1588142694228;
        Tue, 28 Apr 2020 23:44:54 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z10sm29343950wrg.69.2020.04.28.23.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 23:44:53 -0700 (PDT)
Date:   Wed, 29 Apr 2020 08:44:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [iproute2 v3] devlink: add support for DEVLINK_CMD_REGION_NEW
Message-ID: <20200429064453.GC6581@nanopsycho.orion>
References: <20200428204323.1691163-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428204323.1691163-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 28, 2020 at 10:43:24PM CEST, jacob.e.keller@intel.com wrote:
>Add support to request that a new snapshot be taken immediately for
>a devlink region. To avoid confusion, the desired snapshot id must be
>provided.
>
>Note that if a region does not support snapshots on demand, the kernel
>will reject the request with -EOPNOTSUP.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
