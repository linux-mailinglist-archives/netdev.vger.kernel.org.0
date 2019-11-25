Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614B710869F
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 03:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKYC6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 21:58:48 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:46576 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfKYC6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 21:58:47 -0500
Received: by mail-pf1-f179.google.com with SMTP id 193so6617753pfc.13
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 18:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pqb+GA+AV2mbJaXpnj74CQaLRYZl6peQCIBZfhCemGo=;
        b=mLmnZ3WiWCtynypAoIPkluXf7tpYAXDipRfi9QMgzPS5loYdLlgR80ogXxRBI4sdZp
         QdFug1yOS5C3WCORNvCY1PSD/oZf4Vacx+LVa+mPzAHgpGJCpfO0gshsH45I8C527/0Q
         VGNsErGzEetYAVbAjmZK2/cg4OHB19CSyMuE2MlCjStqIkzV2zV0OhCScIukwXiRuBA8
         PaEVfWinovQcGgHHXKrX6a61sCmDu841PfDGXeMKkzEfJD4Ou5aNJYeoGgH0S8ebdjYe
         cIIp9TID4w5m+il6G8dh1S5lTh+qIHEZpujjofDxaKBfXaYD8hEvdn0ysnLxwUbjagF/
         wwfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pqb+GA+AV2mbJaXpnj74CQaLRYZl6peQCIBZfhCemGo=;
        b=nT1BycRRMxZU9CIGDZ7P3CFKKhxvZvMM4yQ4PDw1r/egDBcLorctqS40CJarhWRJz9
         cH+1UiH/BrtaEFMo8/kk1saNrsKyeVxdtB/uJqvJdyn33EQCeERMA7bMR+Fw7AswakK4
         3lDB2jbt2+oVvPIKWC8mQKMyhpdLcc5jW0SuQQkuz3Xb0it9JIDHCIKv/3HXgMjU7Z2L
         +3Pwp6C/8eNz3UNtJY7KLhzlXOun/nXeXy/rdoMzk7xFGhwYB6EqvFlA1mTCxA9YxkJw
         gQHTXSP2OHtBOxrCdog+85+SjVYZDINrTrC1eEuwhkjbDQf6ijcFh6DL0N/z/GNFZ/RR
         6EJQ==
X-Gm-Message-State: APjAAAWUr5v0cztqm6ETZI8jKYaQYTJGPyPteg4n1PRmmEqByBX+5guE
        VbsuWvjXEqHVqbJBhr+w/slxKg==
X-Google-Smtp-Source: APXvYqx7pyfcYNt7vKGiYVY/GTidY/pCIxrh1LflI+Aicjzc6KavANnCBrhTuogtg6qKR2TqcqPgsg==
X-Received: by 2002:a63:e44b:: with SMTP id i11mr29580973pgk.437.1574650727145;
        Sun, 24 Nov 2019 18:58:47 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id m13sm5835849pga.70.2019.11.24.18.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 18:58:47 -0800 (PST)
Date:   Sun, 24 Nov 2019 18:58:40 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Johan Hedberg <johan.hedberg@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2019-11-24
Message-ID: <20191124185840.4edc495e@cakuba.netronome.com>
In-Reply-To: <20191124132645.GA43125@pehoward-mobl1.ger.corp.intel.com>
References: <20191124132645.GA43125@pehoward-mobl1.ger.corp.intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 15:26:45 +0200, Johan Hedberg wrote:
> Hi Dave,
> 
> Here's one last bluetooth-next pull request for the 5.5 kernel:
> 
>  - Fix BDADDR_PROPERTY & INVALID_BDADDR quirk handling
>  - Added support for BCM4334B0 and BCM4335A0 controllers
>  - A few other smaller fixes related to locking and memory leaks
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thank you!
