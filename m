Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14518926C0
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfHSOa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:30:57 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44969 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHSOa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:30:57 -0400
Received: by mail-qt1-f195.google.com with SMTP id 44so2074320qtg.11;
        Mon, 19 Aug 2019 07:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nCUsIESRdWPX9Vff6/n75+p5et6kLn7sYTxjvvWupHE=;
        b=D992ETCQmK8y0i/OPoHvnji9TCiMV1ZhHAU4jecXFoVmIn5klyPgoBYxPmeHEPBUoj
         20rEtJm5J6Ff5sCOM+XMswtGslnn4yJQuz2wgT51hqIYyKtGFQ5Ixj/bUwiVssG3jURr
         xBtJRz87g4BWfVukvRkWkJNPUWRhiuo9niTSPwUMc1lAVw8dzvDOJEIEUrfE9hgV72l/
         mXrSnayX76bXbqlEUpijleOY1MBO3vmlIDynCQ6Lm2Bj4hPVpr2ox62btLwIEGvtjhLl
         fuowdenmFTM9wolu+G8DtyOUpv2vIrPGHPHKL8jUzEARlu0I7goaXcu/oDNebkOiHcBp
         OVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nCUsIESRdWPX9Vff6/n75+p5et6kLn7sYTxjvvWupHE=;
        b=PxiaKP1qOXFLFYM+9z2xRhwyMtbEmKqV4srbfriYIUsHmfGezqO6jqETY7BDBKkYTW
         ff1iDorPfqqTxmtxiNZ2zEvxbY6JOefa/MnmHzh0ZD64BWQuoKFA5kztQ/e5dlXWoTSN
         7vxvh8CpX5EpEzjhDwRfzT2MvD4XalXOsa9NHqhBhBUxWhgsL/ZCWFPj8Bh29RoXeTo9
         RcJf8BfyfEOXiHntvBBngBz/Mo14XCrh/k9kKrgeLJcQcgdA5Rd2IviYfTh5/h/yT8CB
         IHJDw5bztKbP+I3QBsvSmxid7Kjf4Bm5xrQAp6MQzriOW6qlt5WkujF7KnX0RWBU9lqc
         STFQ==
X-Gm-Message-State: APjAAAXo4zeEgTRPnFMfnGAP3OViG05X4h+sAPUa8RMGe+0p7i7mHPF/
        6TUhpwsC3HAgDAgcgnzUODI=
X-Google-Smtp-Source: APXvYqxFP07A0J2hwbA6OMYk9OM72x9EETDAzJ7GBBj86wMyJUghnV2dTo5kiMxbywVy1JYJglsTdQ==
X-Received: by 2002:ac8:1203:: with SMTP id x3mr18664307qti.222.1566225055864;
        Mon, 19 Aug 2019 07:30:55 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.68])
        by smtp.gmail.com with ESMTPSA id l11sm7243862qtr.11.2019.08.19.07.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 07:30:54 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 727F6C1F09; Mon, 19 Aug 2019 11:30:52 -0300 (-03)
Date:   Mon, 19 Aug 2019 11:30:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
Message-ID: <20190819143052.GC2870@localhost.localdomain>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 10:02:46PM +0800, Xin Long wrote:
> SCTP_ASCONF_SUPPORTED sockopt is used to set enpoint's asconf
> flag. With this feature, each endpoint will have its own flag
> for its future asoc's asconf_capable, instead of netns asconf
> flag.

Is this backed by a RFC? If yes, it should be noted in the patch
description.
Quickly searching, I found only FreeBSD references.
