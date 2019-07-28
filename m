Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE827816A
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 22:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfG1URC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 16:17:02 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33883 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfG1URC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 16:17:02 -0400
Received: by mail-pl1-f194.google.com with SMTP id i2so26681662plt.1
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 13:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0PzaKaBRS/lZ7I/jKqnNdIjIQ+r+xDj8+lSwznRFB50=;
        b=pDX5LB6E+pmYnqFbcHdQV/a0uhFMX5PKC0z6A9eayvQu8jaHgKX2e4K0xW20tx+JN3
         ap8AKn6/5awb1UuNC4kUB2HVnFJYE/7HbaA798CAZHYwUTIeKm9zd2asvbwo7QnA4ycR
         0Cz2wqd3A8mGuD3iGtdJt7olGyyAh9FXumskq0ZsxSm2yWL2Kj8FMRvUfvbAcdbcKewt
         hyNC6TzcxiiKdJa2GG+v/W5f+qG9twjneOerWEBYRlZ9++RC/ssz5/ch39lxsOg4l1Si
         Y8SVWqKD7AKnSPVoVrEhV7cLIU1iJKVwf+H06jGa6X5OPR2DYPa1MX/nMiZcRAnXihwX
         /7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0PzaKaBRS/lZ7I/jKqnNdIjIQ+r+xDj8+lSwznRFB50=;
        b=joXw9WPhZJLajeoo03+aEwLjbPErgDs5kClz/aiik8OjAtpIJ6SbGSnWjPzK054byk
         RS3ob4pza+/ehZKrG4xNT5Z5cO91Ry8vEIfnzikaJzXOZvTQDfI0VfpPoDgfsxumIDdA
         LFGYKZ8NTYwSDzeTiUnk1f1w98KYYuE7b4+OLdGfSBsVSJFD/DCvApO4BvSZxTJcOcFV
         ZFUPEaVtq4po6A5MMKj3o0/CC1zfbqCcdQkct7Dqj6rOefKwCEVF2fGpKEY187GVN32u
         78vu4yz3t3fRrcIg64iXsEj4RRBeN3t9tz3VXt83YS6CiOawgpra8mIPFwwaNDhmPgPu
         tSuQ==
X-Gm-Message-State: APjAAAUR/9Ema0jQcP20vhhqpg3cI0G0fqEKdjU+l1DrmRWUEdGUQNtf
        8pE9PcLdjEcfrWGll+Ah7kHLD6sSL4I=
X-Google-Smtp-Source: APXvYqwo6aZDD8JKv7LKbPqWps8aMDM2f5iDy+PoK5UQK4VDgxEkoB+nme1ZmibRMXycsW6R0iLcVg==
X-Received: by 2002:a17:902:44f:: with SMTP id 73mr108004961ple.192.1564345021740;
        Sun, 28 Jul 2019 13:17:01 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id f7sm57836086pfd.43.2019.07.28.13.17.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 13:17:01 -0700 (PDT)
Date:   Sun, 28 Jul 2019 13:16:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
Message-ID: <20190728131653.6af72a87@cakuba.netronome.com>
In-Reply-To: <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
        <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Jul 2019 14:52:48 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> When thre indr device register, it can get the default block
> from tc immediately if the block is exist.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v3: no change
> v4: get tc default block without callback

Please stop reposting new versions of the patches while discussion is
ongoing, it makes it harder to follow.

The TC default block is there because the indirect registration may
happen _after_ the block is installed and populated.  It's the device
driver that usually does the indirect registration, the tunnel device
and its rules may already be set when device driver is loaded or
reloaded.

I don't know the nft code, but it seems unlikely it wouldn't have the
same problem/need..

Please explain.
