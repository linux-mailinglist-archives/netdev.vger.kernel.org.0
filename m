Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6C7D3491
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfJJXrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:47:17 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:36638 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfJJXrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:47:17 -0400
Received: by mail-qt1-f179.google.com with SMTP id o12so11346612qtf.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MHlMgR1RJEreA1J7PlSKMeNqW8+Ucx7jaAWDqbiO9Hc=;
        b=qsVv8P0Rv7c6i2uFgKlMcWDORKnw14YUXQtRVD0V3OcuHgl9LxBvrFFhfsa/voWXJI
         D2aoDap+yLB7EgsGNE7W9XmEFuv1JgkVjZHPfOdXljOugRw6wFFAKK/qC9NlTfL10rnH
         F7s5t/d+Jke36KMMhray2eDULoUOq3ZepuUH2xShrre7GMNgAnY3FvsKqDYN9KPrS9GK
         5M0s/0O/JbR9UwEuFurS+roJInjSrocrUlxmhfmSDA8I7fXB9gGV12cZVoCIlHDJR81U
         jLgtl66hCpJo6ts1Wmuk0qFCtXWUHThsmHHOs8rSqOYb4Licd8Wadma/kC/XGg72T7d4
         LY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MHlMgR1RJEreA1J7PlSKMeNqW8+Ucx7jaAWDqbiO9Hc=;
        b=YHUAWSfdb2Rn88HaJTaMp5v+N1p2otCPW5k9EMynvXAQBrkD2vpJ32wG2ogXvWVO/W
         aWtjVf45K/+IdH7zAY1HCv/DltgkGZlpMLCh8t/Qz15Qxw7Imgq43xGA2J6fp4ere6Ng
         bUqqCPHbaFXqzp4AVX+zHhTUDPDolf5PGpNMDN2fPO734nntJLf1NszRQu1XhRJp3MdT
         HgEykntZj7JLeBt3jN++prXmy/39tiQZ6opRbXKxiiHi3oAuAChckPgavLHh+RqwTQYB
         Hn9FppgYa67+uhNwau+S+iZhorWfpEuAjeMRqWlgIzKxv24tS3V5DaRDt64ErGdeUbzC
         am2w==
X-Gm-Message-State: APjAAAUTB2WtUlpvNK5+oMzhJZPo+h+LpLuWWIdhHjoO2LYslNmd4Ulv
        X4k9K/l0u4iW1TAQ0LGDXrGEUA==
X-Google-Smtp-Source: APXvYqxWibKyx7xQKyCfGMmlKIyFxMNSwFrsC/XimTMAbvYtdqwCGaxsPm2H7C7rRrB1wjyy/AUGMQ==
X-Received: by 2002:a05:6214:134d:: with SMTP id b13mr12687113qvw.228.1570751236144;
        Thu, 10 Oct 2019 16:47:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u27sm4956410qta.90.2019.10.10.16.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:47:16 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:47:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: updated pedit test cases
Message-ID: <20191010164700.6f34b81b@cakuba.netronome.com>
In-Reply-To: <1570654431-8270-1-git-send-email-mrv@mojatatu.com>
References: <1570654431-8270-1-git-send-email-mrv@mojatatu.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 16:53:51 -0400, Roman Mashak wrote:
> Added test case for layered IP operation for a single source IP4/IP6
> address and a single destination IP4/IP6 address.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied, thanks
