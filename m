Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73CD79E3
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 17:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfJOPfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 11:35:40 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:46020 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfJOPfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 11:35:40 -0400
Received: by mail-lf1-f50.google.com with SMTP id a19so1949744lfg.12
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 08:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ArLLdeIqQLVrzhRFBW203YMOr2hNv9R3Gh/JXVhq6qw=;
        b=od1WfcpMqF5tZJGNb7gvyW0I4D/t01PDIuZxCDKl1mpqx/2h3buiQhAcvnO8Tlle+y
         tY/Bya131CQXBNCq2Y7KIZmjauHTQEMz7ppRiqxmuYY5C0zGAmp3KMsR9D9dsz7csDZc
         u+583RwCDg+V+AAQUjl2o2ErtBDJuuJLmf+bxTjqQkp8xQjt2V2LvdWhceOdhr7Yb6Lf
         IeUUGcU19NQ5ctd74LxHN/qqKToAxuqUIn7mOUuJCJNUPgngbmoR5wmhYWzkHmBO/goz
         KNuyWFCXVWYl2Z+4pfkKIbZ4PsAhfUPyA7H3zF5npGWlG3xAjUPY47Imfp54yOgU2yIb
         gP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ArLLdeIqQLVrzhRFBW203YMOr2hNv9R3Gh/JXVhq6qw=;
        b=tS2PYtBnKf/rncAPiUCgTgcsYZIiVhu1r8sGisNqyzamkXuJRtF2Ojq/kEYaE24qNC
         n/rcSjna6LoFmpLcgJV0REZRZFL4YK+UPq75CMnHlzisUEKBAur5tTncAboMJEdHLqtp
         KIbl5GuiGqfGQb0Phyn2cqiZUSOecEFoN6a4SngiYgUFn1im3RYWT5hmGarBQn/VoUYq
         NGifEbST/OZWBuoKQ/hT75FFsMSO7IyL1Z6I+pylzBbTfmE8dr0hTU25IiuWOF+mPckr
         EWHm12Y9fUTY+YOE9qNql+4vn7g7h0slbE1s3SP94lFqLM3UAli7Vb7AZKhK2BYXmfdP
         M95w==
X-Gm-Message-State: APjAAAWwsLl9X+Ymx5ZbFT8dDSlqumaah2uvvY0otaTHRqBb2aEe67TX
        O9158Tuo8aTjCtxG2zgucfnR+3VbGMQ=
X-Google-Smtp-Source: APXvYqwuULKmklmWOMkP4c/YH/Uyj7PlLVEiBbWg+hhtvk2l9QcmE/qkFDSKbyqwznAXqdlYpwm9OQ==
X-Received: by 2002:a19:6f0e:: with SMTP id k14mr21597596lfc.34.1571153738173;
        Tue, 15 Oct 2019 08:35:38 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f21sm5968552lfm.90.2019.10.15.08.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 08:35:37 -0700 (PDT)
Date:   Tue, 15 Oct 2019 08:35:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, rong.a.chen@intel.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] selftests: bpf: don't try to read files
 without read permission
Message-ID: <20191015083530.0bd551d4@cakuba.netronome.com>
In-Reply-To: <20191015100057.19199-1-jiri@resnulli.us>
References: <20191015100057.19199-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 12:00:56 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Recently couple of files that are write only were added to netdevsim
> debugfs. Don't read these files and avoid error.
> 
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
