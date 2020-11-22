Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BF62BFCEA
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 00:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKVXKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 18:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgKVXKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 18:10:00 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6948C0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 15:09:58 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id z5so670404ejp.4
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 15:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YTRoDs7ILqor7JDRHtYVvwvad60V/hmlziluREG5O3s=;
        b=mgQMQHM30uNyL5QYCOxNEqxAP/3osHLq+RQHgqq+PeUuWBJdEE4UYYpvo6mTaPKr6r
         m4ml5Fndplv/jxL9nIq3Buj2drOM0k9M35QJyi49/hk3FFs1GgWNAVLSGPq3/jKDutVI
         RQeMJdXHaUev3J+xxPuhulZwqJan4OLO41XzfiunbksVQsEb4UAr5F7lzc6/clFRWHpI
         iQSGJb4+8kxPcpIbTGsQTIq3VCGgih1NmHqXnd6EjOSjJ676Jp+hM7ca9IShRdTCemV9
         +qdt2YDwBVQZqFBaUTY0IIZj9YGhBuKIrUNTzuuTizvJxxdqE5ALGlRwv9GRwQr8deBC
         bmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YTRoDs7ILqor7JDRHtYVvwvad60V/hmlziluREG5O3s=;
        b=pQ/IfVNLCsvy785ji+I5AqQ4Phx3QHFDUzF0rYsfVnaEoFTCDzhdy/nfkjUaF1DlyF
         DAPGnguRep7wC9I6VJ2cigGkXWEAFCDMwxlenH/TsHR9CatfhHzIoJA4um8jUAfJKVns
         MPf1bzx/oH1DP0BhpR+9ID6IrWnaGsp/dzfOGeEFdnRwYuXJcB4CEKLTZ4b+SSfo1GiM
         Te6SRhtKSlU9yuhM6KmTV6sOLmMHC9XzafpBA8+/jLzXmjIYEtT5hXlhDKZamroVEavW
         HP9OtWFIuGPiafYBsJ5PwzK8HhA8P5ZISM2+HpHEQTH0X1wJUR/LJA9Ew+JM8hBMNEux
         CfHA==
X-Gm-Message-State: AOAM532EGKPnSbD5Xsj2e78bDLy7sHyPKwtFV7sCTCmub+UMfWQkJPeE
        C09AgSA7oE7igFFDyAcH3As=
X-Google-Smtp-Source: ABdhPJx7+J3tGLA+97pq+TpjCm/hycizLTY349+vVUj9CApbVWzU/weY8n7FkAe3q3caEGk3jdCL7w==
X-Received: by 2002:a17:906:9252:: with SMTP id c18mr19847823ejx.489.1606086597692;
        Sun, 22 Nov 2020 15:09:57 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l8sm4024625ejr.106.2020.11.22.15.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 15:09:57 -0800 (PST)
Date:   Mon, 23 Nov 2020 01:09:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_hellcreek: Cleanup includes
Message-ID: <20201122230956.e7yf7hav2ekjf57u@skbuf>
References: <20201121114455.22422-1-kurt@linutronix.de>
 <20201121114455.22422-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121114455.22422-2-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 12:44:54PM +0100, Kurt Kanzenbach wrote:
> Remove unused and add needed includes. No functional change.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
