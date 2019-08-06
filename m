Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF4F83D41
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 00:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfHFWPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 18:15:51 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36221 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfHFWPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 18:15:51 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so86359594qtc.3
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 15:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yVcWYkkzAVBWRmZ0DK7bYffmU6FU9N6ado8O6IIQho4=;
        b=vO84MS8CKoIJfWDX4UFm0l40mw14mmDz/6H+85o1Fb9uOSVphDCCbHc13po45EP0Z4
         wXdB/QXwJH3g4duppJOSUbE6odymRu/NgH+pr2P+cDLfcXNLuU/uz/Cf2jOvT8vA4c0A
         a9FFcVsZvn+4w5/ujsXsHHsd88fsGa3/cC4dJygHmgsoNqwC1QRTnAFU7Vl7yQeqj/gf
         Z1cHXhkuTYHPmSYBAugMg3Sy43duFm4tWRKDPYsZ41i0N17fYsvd0SVQG+olHNqn9RD4
         wSWSUJNiBbchVH3TlF0hfxCcNymjRPBwN8GOeq0Cmj+0/t7it3MH/FvdWavfIpEYFzwU
         dKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yVcWYkkzAVBWRmZ0DK7bYffmU6FU9N6ado8O6IIQho4=;
        b=BmnkDLHJRn3fs9iWhLWuxjz0v2IX1wDUOieySCBgQScRmZymeikfWrqX+Aao74+ntx
         mvt00moVHAa9A32zBjTECNUjCukHBVNazRWQ5T5F/bL9dpet7vgUTFg0FfrPMurGQX+i
         Fqp8TFGBVnw4O681FRGp0WPuJl7hUol2oGTdEoO1LCCZZ+RGLgH+Pf00OLdjsu3fyhgu
         ZaPuPUBRsV/iIo5cb/Qq+/2ODOBj84iU6ZF7NG3fDPeD9Ht0tGJj+w+J56m30J+Ckbsp
         qFR0L9MU5oYr50c6gCxZD/CQEA0gaUQmWkTguVLYoePMQWlXgwZhyrQPLc1IHbFxf4hd
         Cxlw==
X-Gm-Message-State: APjAAAUP7V3exFJpgjh6ASZN47uthCW9S8cI7f0LN0m6EdUjh0031vLV
        i70WPBTTcKdVYhFiZycenL6vc+sRyfc=
X-Google-Smtp-Source: APXvYqzLPLtbPIF/9YqtOwJARgaNU8oLbCzg3y8+Sy9wYHWfic5HgglnBpWrrhOG0EUzqY/ZH5PauA==
X-Received: by 2002:ac8:5547:: with SMTP id o7mr5292130qtr.297.1565129750072;
        Tue, 06 Aug 2019 15:15:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y67sm40298563qkd.40.2019.08.06.15.15.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 15:15:49 -0700 (PDT)
Date:   Tue, 6 Aug 2019 15:15:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     mpe@ellerman.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next v2] ibmveth: Allow users to update reported
 speed and duplex
Message-ID: <20190806151524.69d75f8d@cakuba.netronome.com>
In-Reply-To: <1565108588-17331-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1565108588-17331-1-git-send-email-tlfalcon@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Aug 2019 11:23:08 -0500, Thomas Falcon wrote:
> Reported ethtool link settings for the ibmveth driver are currently
> hardcoded and no longer reflect the actual capabilities of supported
> hardware. There is no interface designed for retrieving this information
> from device firmware nor is there any way to update current settings
> to reflect observed or expected link speeds.
> 
> To avoid breaking existing configurations, retain current values as
> default settings but let users update them to match the expected
> capabilities of underlying hardware if needed. This update would
> allow the use of configurations that rely on certain link speed
> settings, such as LACP. This patch is based on the implementation
> in virtio_net.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Looks like this is the third copy of the same code virtio and
netvsc have :(  Is there a chance we could factor this out into
helpers in the core?
