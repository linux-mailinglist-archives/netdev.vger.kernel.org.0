Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD57788472
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 23:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfHIVPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 17:15:22 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:42935 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfHIVPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 17:15:22 -0400
Received: by mail-qt1-f169.google.com with SMTP id t12so8618539qtp.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 14:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=VP6aV1UAaokayWiNJ9jPHSBK2w/ThvQHMm50SkPfhBo=;
        b=MFXFKt28jP+qDKcvbngvZ10dnEt0GOE+EsoIs/pHbzVorn0OaL/uUYbpur1mgd0gTr
         QNw7KORfyafwiKEIF6+1npmImTtzq4LqENKDy8L6CGrU/syKQQUfzLXZNIUpqDLsgEoA
         pAyx03kSZuGYto5mS6ECMMzDdGtRUEasvD/u8lkih+/8tr+tLNUKR9wNzBNBBDI3G+jK
         3OyRYApTt/gcXKZIM1JMOqI6oLcJ4ik3NnifIZ7y9E65SoCxeBvqQb87lJr7eLN3YUNt
         F7zCV/0VcjDIgQq7TeOxV/AFDrHLzCABYYTkNC6hSsBE3h9bJ5p3NH3gO57xaIhrRyHq
         tKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VP6aV1UAaokayWiNJ9jPHSBK2w/ThvQHMm50SkPfhBo=;
        b=HsCUto/54hguzzWPl78iby0RYpTX/DJgXostgcrk01qB6S59OTsMGaXa8WTAzwyFx6
         tLoHtDloFIcrnf7kHreYy71+ws6u2LhflfYAGubw3vtVWCSucs+n/BmXzeUW7BzHy3lD
         n41YEfwTQ79rNxRd1kt9tbXBsZyU6bLX88ZfvPVDGxRzcGTk/VAgmyHBZfXnXDQEol3E
         I+Ok/uJpPlA8mU8rBTGfXvfRcV2qCd+7wKi2pq2RKTn+gAXaZYe2FuxmmR960U6s2BRw
         u7OqNmk965UEDJeQ42Z0+wGjibcllLekQhpKIz65wvo/TIQgbQ9cn9cZXV0Kdw3/PUep
         bmLw==
X-Gm-Message-State: APjAAAWVQPA3+wKjOS0JtOR3LzMb0od9pgdmc6IKai8g9OPPTvO7Toy2
        RSPDDdCjNzB/sl8vZCi3vvTxDw==
X-Google-Smtp-Source: APXvYqw3WX/A8VVGeDK6b/gUQuCrxhWXCWaTvE5qyHIe4wHrH1N+liFF3RZiyFwoh89kLL4zI8NUrw==
X-Received: by 2002:ac8:ec9:: with SMTP id w9mr6628156qti.95.1565385321729;
        Fri, 09 Aug 2019 14:15:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m1sm2975386qtq.34.2019.08.09.14.15.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 14:15:21 -0700 (PDT)
Date:   Fri, 9 Aug 2019 14:15:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Henry Tieman <henry.w.tieman@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 01/15] ice: Implement ethtool ops for channels
Message-ID: <20190809141518.55fe7f8a@cakuba.netronome.com>
In-Reply-To: <20190809183139.30871-2-jeffrey.t.kirsher@intel.com>
References: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
        <20190809183139.30871-2-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Aug 2019 11:31:25 -0700, Jeff Kirsher wrote:
> From: Henry Tieman <henry.w.tieman@intel.com>
> 
> Add code to query and set the number of queues on the primary
> VSI for a PF. This is accessed from the 'ethtool -l' and 'ethtool -L'
> commands, respectively.
> 
> Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

If you're using the same IRQ vector for RX and TX queue the channel
counts as combined. Looks like you are counting RX and TX separately
here. That's incorrect.
