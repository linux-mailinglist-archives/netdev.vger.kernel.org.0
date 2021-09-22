Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428674143F7
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhIVIpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbhIVIpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 04:45:36 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FE6C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 01:44:06 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t8so4507495wrq.4
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 01:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DYNFE2/nmesX5uqKWFKe+/JpWiTc/nVrxeF5GEQjjb8=;
        b=VbxrqfN0LPfvldaixpDfswKrlJ9HwMVllNe070nisXhslIGwBt7Exfw1rFmck15Zge
         Wu7t17879SWLZJelmwg+RfRbWHT9mmpYgNvG3fMKCeVS6Bh4TcQAOaVsStZBUeTokhJk
         rXe/8FMN6frxKhk8+Zktq6/YlUhpyzAeATGzJK7nrSS1J+Rycob3uDHzqJiujXIjfKRp
         nzUg0DOKd2AnZCC/w89JvvMvnJxWfj047BLb3PlFl8Ly+L8a3v2FstMrR8yt5JNxVwlx
         bowxhuqoaybG4mY+Nmu52O7oSvSn4m+A0W8x6TGIPvjgeTZO7azQC2JY1VL588y+LwvD
         xZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DYNFE2/nmesX5uqKWFKe+/JpWiTc/nVrxeF5GEQjjb8=;
        b=mx+zUAH9dEZB0PqH0kZlxEz5fwsStMBhrNpPWZ3v9B93FBe6bZvomLeZ3EW3juPRMR
         mORM8yNyBonX/jRdyshrrnBAdg+75axRbtLE/BodAefuunFw5Wi9co0p6RuqnIFcQQes
         y4XruzOwtQFS01pdHIIfbs10e+SyIkLzAGWZmGzkFvpHNrFqqrsBWlF+iIu5bN9qJVNb
         qQQq3RYMNY8v46d4e9xBLYMWy2QCpb350RXzoEuKwJ9skNp2GMOA0eQ/kZVic8LAH77V
         ipYCReYUKgDzQ4NjFeT5k/4b1t2CFnrZkbVWlFacNlsHoN5N3wxeulbQOCaYnL3BOoEt
         OnaQ==
X-Gm-Message-State: AOAM531sD7u83IC/TV/PfzSJw+D6XEVmrKDm+xndLsTAx38uXeKBJYsn
        VWswWVE5n1uzgFH6whBQAJNZX8d7FGY6PcftsJ4=
X-Google-Smtp-Source: ABdhPJxQ45V2dp3F/AEvtOkEY8KSg/sE4FDzOdFIrtjUDII7+Bqga5drLghzMCfpVLiS/9MnWHFTmA==
X-Received: by 2002:a05:600c:4e8e:: with SMTP id f14mr9388087wmq.13.1632300244828;
        Wed, 22 Sep 2021 01:44:04 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id g205sm1331765wmg.18.2021.09.22.01.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 01:44:04 -0700 (PDT)
Date:   Wed, 22 Sep 2021 10:44:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/2] mlxsw: spectrum_router: Start using new
 trap adjacency entry
Message-ID: <YUrs0sKiiZiGjne8@nanopsycho>
References: <20210922073642.796559-1-idosch@idosch.org>
 <20210922073642.796559-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922073642.796559-3-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 22, 2021 at 09:36:42AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@nvidia.com>
>
>Start using the trap adjacency entry that was added in the previous
>patch and remove the existing one which is no longer needed.
>
>Note that the name of the old entry was inaccurate as the entry did not
>discard packets, but trapped them.
>
>Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
