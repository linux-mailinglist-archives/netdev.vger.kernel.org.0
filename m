Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA72A1B55
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 01:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgKAAKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 20:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgKAAKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 20:10:13 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A496C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 17:10:13 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w25so10517455edx.2
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 17:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eIIPRFbh8eucVtMne8GiTAaie1ut+P8FbWn/8oOzU3Q=;
        b=UEap/xKdahf7PGK0IQkRmq27LAopbNM9Nxc2LQ5MuJvuIuqa4xY3I8HBk2nQhpysq6
         lgzj+UEGjXDp3EnMy5Qp1xV1WJG1hUtxtODHm67zgQVoiZ06TGC9+ytGK3djKmwfRsMH
         /cuvyCCFjXQiPubsFeEr2873Oa6FKLitr0e+d2Y84MEUv5NfsKERrRVp2p6fUmVpZuZP
         R0E778CeuzovfLcDOTXHVZhv6dOtMtzyp1lD35aS/eXf5maFaoWvRTXuwDa1DgWgt2Ux
         tWxgKt7EmY3pQUNMu1023A2Lq2CCOQjFjnyOFPLeyvI9TJdc+PlXF7XogOYt8gpO5hUk
         gMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eIIPRFbh8eucVtMne8GiTAaie1ut+P8FbWn/8oOzU3Q=;
        b=k+B/zC4t1xijXCxsbMx8SJd2aq+CDIjTYVBGMViglzrDYR5YCKv+tGba4RfHwal3ID
         Y5SrQMqv+2UXr7FLPBm8TiUOM79vX+K5stymXPwWHqIG08a6rYRxIWDMX3Ln0+QYAE5D
         zjlpEqeW8VdShMRUKywPqpJ/6J8DYXkL4xHbgfJY02tPN4fdehlt1P56C5geKn50yqYX
         7gYjafZvNi8wly6POUe8SbqKzIz3kIusUz+dWbFpQ/nPHMuIic92K3D+U9CzcvkfbQ0b
         7xYS0pQ1X9ZisvniuEkOfvl/7e9QBfFd/xJBKDMkmPgzdtg/EE9bHdwx878APL66JRzk
         De0Q==
X-Gm-Message-State: AOAM5304SjIgMHcu4u+Y0wKc3QDtJJMZiImz3MYx5pIuEPBiFkYCtkeB
        vNT9JR5vIiOiigrrKOQaCaI=
X-Google-Smtp-Source: ABdhPJwWpxFAjUywimrNQof4e9HwumBJlOCiRjekQ3sXSoLEJJU050WpPDOlLqCYPMUfYIOE6gINrg==
X-Received: by 2002:a50:bb06:: with SMTP id y6mr9837272ede.278.1604189412407;
        Sat, 31 Oct 2020 17:10:12 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id w25sm5993750ejy.123.2020.10.31.17.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 17:10:11 -0700 (PDT)
Date:   Sun, 1 Nov 2020 02:10:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [net-next:master 38/46] net/bridge/br_device.c:96:7: error: too
 many arguments to function 'br_multicast_querier_exists'
Message-ID: <20201101001010.t7y26ozvh2v3xjyc@skbuf>
References: <202011010816.xqRrTSz5-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011010816.xqRrTSz5-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 08:00:18AM +0800, kernel test robot wrote:
> >> net/bridge/br_device.c:96:7: error: too many arguments to function 'br_multicast_querier_exists'

Oops, I sent this patch as a fixup:
https://patchwork.ozlabs.org/project/netdev/patch/20201101000845.190009-1-vladimir.oltean@nxp.com/
