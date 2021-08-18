Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4453F09EA
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhHRRJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhHRRJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:09:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ED4C061764;
        Wed, 18 Aug 2021 10:08:49 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j187so2783083pfg.4;
        Wed, 18 Aug 2021 10:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M71yeZtn0Mun3ZvdAVAmKe6cwHYWfdCa6xD1ze29eOk=;
        b=eSI1HCjh4Kl6cOZHIBRVDdCsWKr+5XL5Y1ma4RLKwOto7zySlZunuiaBhdzu3t7x0g
         JhkjjJ9e11TtkFw5I0fq5ujIlqgwC6LRqOyKqcfIEEYIdiKa9SODn0xOsEKeEIS8qnAZ
         Uy9xorihpMF2C2+Nn6mF+PPQuliZQep+xePSJBy3R+Knk0tODf2CHQTQacUzFXCIATCQ
         EdXgQQ/f0Peao9Hq9Vc28705MaMt6X6giB6Ygu0TyRziy63Y2o+2Q2kgRva7a+EHSLF5
         /yFTfQjVlU1T9m1ZK6puh9nRIY8lfOdVcyGdOFn6O11gLsjk9wV2C2yBgzU+PCEk+cSh
         EnhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M71yeZtn0Mun3ZvdAVAmKe6cwHYWfdCa6xD1ze29eOk=;
        b=eTlrPPNK3bCk6pQL7sFnQUUyOLE0rFeQG2mHxVF674GrFgmuBOc72cCgmK4WntXDat
         KN3+k0zvPUz95aqEkf1NxbS6VMHvP9OZmz3Tt2Ie9G9/JtUbON/GRmlUT4SYOENBJUSB
         gyg4B9w8QhzmoBjOvucyYLuOrw3D4ANwRf0+zLoh/PmzoL5SG1dKBLbLBzzzxWxNHUwT
         uJ0OGCvj979wyHS43pSt6KU62XeBvZFbzvMEeF61GQ4OU6zcTrtW5GH7xri+vplfoy+9
         TjuIqlwWN4kqOGaszORisLQQhmyxVvuk/UXgIhYPGm3aBc7oTy/YU1yQkaZNtiet1q2b
         z5uA==
X-Gm-Message-State: AOAM531pM3Kj9zcFRdMOv8ZBJ+2f4OwM3EAPyQo1uqS4Dgpn1KNgMPbf
        3qfkwiIFOttRYDSLe0gHDXE=
X-Google-Smtp-Source: ABdhPJw3R40Uavn6HH+tNvVbXV+cgGaLDjHn0YN8aESokpiCkJ+872e8mbpXwzGHN61RBJu98HTrMw==
X-Received: by 2002:a63:101c:: with SMTP id f28mr9842153pgl.330.1629306529482;
        Wed, 18 Aug 2021 10:08:49 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k22sm305834pff.154.2021.08.18.10.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:08:48 -0700 (PDT)
Date:   Wed, 18 Aug 2021 10:08:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        arnd@arndb.de, nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: Re: [RFC net-next 0/7] Add basic SyncE interfaces
Message-ID: <20210818170846.GF9992@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 06:07:10PM +0200, Arkadiusz Kubalewski wrote:

> Multiple reference clock sources can be available. PHY ports recover
> the frequency at which the transmitter sent the data on the RX side.
> Alternatively, we can use external sources like 1PPS GPS, etc.

There is a generic PHY subsystem (drivers/phy) used by USB, PCIe, CAN,
and so on.  Why not use that?

Thanks,
Richard
