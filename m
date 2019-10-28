Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008D1E7B19
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbfJ1VIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:08:22 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:37642 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbfJ1VIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:08:22 -0400
Received: by mail-pl1-f172.google.com with SMTP id p13so6312317pll.4
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 14:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/oI7Xyy8BI5Ew/Z7MXiiQ1QJ/VMfsgMXijwkArEQ5C0=;
        b=J4z9yfivia9eSd3G5hmZgi4LPivlaos6e6g2flu0c7RmPusW4yVTBo0BEpcj1uzxDV
         NMvueekFgh/b91zunEAQAoCgnn9D2tRtykeSFuLgxCGc63k3AXvP/FNxzC0HN34klDij
         YQtTG+v7dBixTB3Se+idtzf/tJIqyVYltbrGDBK1b3H6czE5iW9LPOF6nncKEH4bH0Gf
         /M2kj/aHAmsOLcMLYt9O3UDORYg1flvj3kV39TA/D5V1drxgz1mUJD2Z69GwzM4R38pq
         rNLwz9g4YMfkI9xDdyBfVxot2Z45yiC2Ryv2Qn5jvimzYR/ooHSszNGVuaI3pfvfXafq
         1CGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/oI7Xyy8BI5Ew/Z7MXiiQ1QJ/VMfsgMXijwkArEQ5C0=;
        b=dpgzyMdWjBo2Hf4hdR1UPfH6TkeUmfaYZRn8abbqMfDT/b5vZ+rDJmtE5hLaKFuW1a
         DCJrmAbQUAmnPKZg1eYxuPyPooa5agaEZYZQNg7jczv+L8pBsQLoN64a3tftIo0O7QH8
         jH4ph4sV7d4uBTCvwuTpjR23gAqp2ABuWgkR1BLw1q5lQG4qJsZ1bVSXaZpEfE6+O2S3
         ZEGABu/dCnFc0Rh7wpzu8OBc+5l96/DdxcHXn9absaC6cg04Cu3KkZssjO770rVwwMqE
         NhNhELY6tQ906vZAeLmisssEZ+0NMxxigXP5as6Pcfn32gXpOM4JMQuauXZchrSQRP3U
         8oJQ==
X-Gm-Message-State: APjAAAXj8Xq5Ck9KYNQ94wDzGeHR9X5pOjxpsWXNJmGDmO31cNIXaWwn
        83Nh04Cs0ivlpZXDFzENj76xZA==
X-Google-Smtp-Source: APXvYqylZz1hegNfqaoUv4DJfJiP3phWZ+WIEHCFk6il9djDD1O/wLlzXbOC69W1sbGiy+El/YZAcQ==
X-Received: by 2002:a17:902:b687:: with SMTP id c7mr121843pls.52.1572296900677;
        Mon, 28 Oct 2019 14:08:20 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v2sm378313pjr.14.2019.10.28.14.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 14:08:20 -0700 (PDT)
Date:   Mon, 28 Oct 2019 14:08:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 0/9][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-10-25
Message-ID: <20191028140817.46598bea@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
References: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Oct 2019 13:42:33 -0700, Jeff Kirsher wrote:
> v2: Dropped patches 2 & 6 from the original series while we wait for the
>     author to respond to community feedback.

Thanks, FWIW these remaining ones do look unobjectionable to me.
