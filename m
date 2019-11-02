Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5786EECC4C
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 01:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfKBAVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 20:21:14 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44736 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfKBAVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 20:21:14 -0400
Received: by mail-lf1-f67.google.com with SMTP id v4so8376717lfd.11
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 17:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=R9fVtkedUPJJ1bv0VTt95yl7DEhnOVCx6dE9AB/eBzY=;
        b=Yx8eNrOPxnblsZHKyOY2o4IwY1EScEXqOCM7GfmWiCBHrVv8YWq8bE67v8M5o6PKlp
         QZQXjlKL63stmq9E7ceqqkOg2AvA+TEy6EZcTM2Fhy8vLaj1eqTqOCmx2MlR7WnCdjCm
         7mtBA9Xh0XvhinvMSB7unz4bhTdmsUm0ULJYH8aTYPQx/g/hqUxdtCNj/O+mRJMeiF8L
         WHHRPNh1+fPWA2tTrZBXtB4noVnMb2s3htRQGiTC7vGvFUIvNzINCQhXscp8tq/eAVxz
         pbIkIeOuq23rz5wrU3EJ+jvfq3MLY6adNC475PeU1uhfDHBdw+nQdNbumahZP9qeWq3a
         HC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=R9fVtkedUPJJ1bv0VTt95yl7DEhnOVCx6dE9AB/eBzY=;
        b=kNiiQnCgQy1WK8pqeQ4JMZbo097ISo/eet+AUH5CpRx7+FPwrQfZRYgavDD3nShy9Q
         kPGD4d7049DCbWB41iXUOZdPFj5KjwRcD6AHnauQt/9QNycIVP9jYnI05o1aRo8PpzJz
         TXU+YcHAvBxSZMpYigd2NTzSrsSpoEwYU+j8USwpUJLrutPhG+7QqfbhL0G/H9FGuOOk
         xTFQjAGmgHI0nGBAp/pkHMflIAO+OB0Z3Fw8+9LQ90k/CuS0QYOmMknbWepqqda6gB20
         3rndEpg8rxWllRC5yCQpX3vbld+GO0r/8DfZehGHqZ+InrMCaOYLTFnWo0uVYvbIhXn8
         Cwcg==
X-Gm-Message-State: APjAAAXPQh+js+KUmDwomkGizK3v+z5McFkiMFfz4qnVQKwusL7MzoOD
        9+Kd78i4CTb0gaCUS0tZruVp0A==
X-Google-Smtp-Source: APXvYqwP9Dj01m2qfD+Xx6JC8Vu91fu+1nUOLIRhFGevQNYqK5DXxGyk8ovtKaHfFaKNjQgcMwiWGg==
X-Received: by 2002:a19:5211:: with SMTP id m17mr1207209lfb.126.1572654072434;
        Fri, 01 Nov 2019 17:21:12 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k26sm3862124lji.18.2019.11.01.17.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 17:21:12 -0700 (PDT)
Date:   Fri, 1 Nov 2019 17:21:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Ariel Levkovich <lariel@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Message-ID: <20191101172102.2fc29010@cakuba.netronome.com>
In-Reply-To: <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
        <20191031172330.58c8631a@cakuba.netronome.com>
        <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
        <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Nov 2019 21:28:22 +0000, Saeed Mahameed wrote:
> Jakub, since Ariel is still working on his upstream mailing list skills
> :), i would like to emphasis and summarize his point in text style ;-)
> the way we like it.

Thanks :)

> Bottom line, we tried to push this feature a couple of years ago, and
> due to some internal issues this submission ignored for a while, now as
> the legacy sriov customers are moving towards upstream, which is for me
> a great progress I think this feature worth the shot, also as Ariel
> pointed out, VF vlan filter is really a gap that should be closed.
> 
> For all other features it is true that the user must consider moving to
> witchdev mode or find a another community for support.
> 
> Our policy is still strong regarding obsoleting legacy mode and pushing
> all new feature to switchdev mode, but looking at the facts here  I do
> think there is a point here and ROI to close this gap in legacy mode.
> 
> I hope this all make sense. 

I understand and sympathize, you know full well the benefits of working
upstream-first...

I won't reiterate the entire response from my previous email, but the
bottom line for me is that we haven't added a single legacy VF NDO
since 2016, I was hoping we never will add more and I was trying to
stop anyone who tried.

Muxing the VF info through linkinfo is getting pretty ugly with the
tricks we have to play to make it fit message size.

And you can't really say you considered your options carefully here and
reviewed the code, since the patch adds this nugget to a uAPI header:

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 797e214..35ab210 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -180,6 +180,8 @@ enum {
 #ifndef __KERNEL__
 #define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
 #define IFLA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifinfomsg))
+#define BITS_PER_BYTE 8
+#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
 #endif
 
 enum {
