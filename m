Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C967A8E1EE
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 02:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfHOAmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 20:42:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39026 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfHOAmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 20:42:45 -0400
Received: by mail-qt1-f195.google.com with SMTP id l9so724308qtu.6
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 17:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2/N4xAxWdCvqHXbe1CHu7m3d9HrUf2QSlKw+m5imRp0=;
        b=Xug12OyaaXvOmrV8hiETTQ9lRrclPx9Qkbv0WqkKq4DXb4tmfm/nt0ALhFuTBwR+WR
         IHJoVlUM/xcCMiRk0+J4PznkpbSrrecjVLH57SioHBIZPbGdpqcY+hzSJDXb+FWyBtRs
         oFnWvXW5UpA3gc5vh+fk+qtzR3UJUYY8t+420mwJfARoaaoh30GtKhycJjCY3MFBozhZ
         XtuPzXG+H4rMAAW9HNIuKZM7PF5fzZtysBAfHAmGDAsKdaIaJlzS7FK1LghimS/LS3V+
         8rKDKg82L+NZzkRLWmi/2C3h44cr2DpTlWnz32PJU+zm8wKYLNRQ1NB70FkRABj7aSpJ
         nRgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2/N4xAxWdCvqHXbe1CHu7m3d9HrUf2QSlKw+m5imRp0=;
        b=iy7cjFDM0H6aZJ6rExGmHUFzGFBBzhH2uAJYtaZS+WBptlQrGHaPagFGRg7IVWo8E/
         S45BFL1ABuRSB9rxTyCn/SYOIN1U2JIATlVLxoROpexG8l/XtzY+jYhl29K/4CEo1qzV
         68KMgQD5435gTn8rWMQij6XLMCBDcj1ozPkflOgFbiQi+DrKv+epqQhqqZ4mfowvmFgV
         pj4XWmvgDUl9Pw5cc6//+1OlniypMMZ30BuFUEHfVEkYmHyOmorThqNv1zAZMatNzhrK
         FbHUtYDh32L1hCuCmuWY4ICL2IccfWe2AP/4QntZrqQLhxAKbT6IuYJtHNLeEUYXvyLJ
         0n/A==
X-Gm-Message-State: APjAAAXlWVuZTcTO4g2CWgY74LbbG4WGs07IjtlM+Ggl6qwGqYbDLDnU
        pmIUdVm7sFoxJmrS0UDbv2XOEQ==
X-Google-Smtp-Source: APXvYqzUt+ujgHZADKwhTTBEUmmvX/7+EyeBuOhC5BpGdiGU7vISHVIPbG9zBq81lN2+M7G9NjFbzw==
X-Received: by 2002:a0c:bec5:: with SMTP id f5mr1670787qvj.54.1565829764479;
        Wed, 14 Aug 2019 17:42:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g207sm665775qke.11.2019.08.14.17.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 17:42:44 -0700 (PDT)
Date:   Wed, 14 Aug 2019 17:42:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jiri@mellanox.com, toke@redhat.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 13/14] selftests: devlink_trap: Add test
 cases for devlink-trap
Message-ID: <20190814174229.1ab4fd1b@cakuba.netronome.com>
In-Reply-To: <20190813075400.11841-14-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
        <20190813075400.11841-14-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 10:53:59 +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Add test cases for devlink-trap on top of the netdevsim implementation.
> 
> The tests focus on the devlink-trap core infrastructure and user space
> API. They test both good and bad flows and also dismantle of the netdev
> and devlink device used to report trapped packets.
> 
> This allows device drivers to focus their tests on device-specific
> functionality.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks for the test!

Should it perhaps live in:
tools/testing/selftests/drivers/net/netdevsim/
?

That's where Jiri puts his devlink tests..

Also the test seems to require netdevsim to be loaded, otherwise:
# ./devlink_trap.sh 
SKIP: No netdevsim support

Is that expected?
