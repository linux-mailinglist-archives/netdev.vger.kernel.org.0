Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90802199699
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 14:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgCaMdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 08:33:00 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:40850 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730660AbgCaMdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 08:33:00 -0400
Received: by mail-ed1-f45.google.com with SMTP id w26so24879582edu.7
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 05:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RHcExkVo3NOWWhELPtGWV2S+6waL7pZiVJTiXXoDYKA=;
        b=SQmb3t25yXLIZKwyQP95IJ1yPsTuxnAZ+mFcYavjCZvtQNI3IJgPV12yYkV+1ALnzC
         ku56X1b6RRYIVWoccy41OlGmij+vci6L+T5HnzdgdL1LUWJ46M25lP0zYJXkrOJTgVAF
         FNS2uKUjq3uNFDp9GwEHt5yXBYJ8GqytLiu6gDOcuPL+tsEfxy0yMZx/gmior936xdsS
         5uiffju5r+z/Xws2cTHFuQTl3NyhpSJyuCx6cjMerKdJ+RfTlrp/GEzlM+R78xmIjLhA
         xTP/7i9BK7GyDeL86w9joHkld38c8bE6h3p6BckZA/hdXW/S+pl05CQfOwY0suTvU9a3
         bTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RHcExkVo3NOWWhELPtGWV2S+6waL7pZiVJTiXXoDYKA=;
        b=DPo6CacV3FCKwU5512hZgS1kZoiCTuql2RPfaJgnM8qD9l7tP7J7fq+RqCcucsq8dB
         wYzR+NiTl8zje90E9hKMRVENxR/D4PoFgTOqD19UsLv1JXyag//9RRDsYh+oRscoxV7N
         SsFA2kmbUdRJajtGjsQ28KZgOeyy+lZpAUHFC2bVvIFvwHHGMLKtrKEuaJ4hartxh7dX
         2+gIMHUQ3rn3uzphassccx+3bKLZdLXYL9yYbV8oYjcyMGZ2mHo+e74mk5we/uIOr9CL
         0b0YiEyNGM6HAAhGilEx2eaD0Q2yZ8CwBY1fXttNq6VWC2/pW7SoagKnhhsRaIOvQkyP
         cv2A==
X-Gm-Message-State: ANhLgQ13MXd8IlBq5CpofZD6Gzm7PLBtKbOyfe2upQlUUJOPA9rVe2fZ
        gxfLX+rHq6azqqMuxD4+RsVduQ6A4cQs++PLT93puHaitfI=
X-Google-Smtp-Source: ADFU+vuh97NQcG/iOaGCfwhVzhQ1X5/6ShAeTieTdRi1g/brFS2cj4ma9fmgsuMjTb/3s5UVEd75BD3GSX6k4PLROBc=
X-Received: by 2002:aa7:d315:: with SMTP id p21mr3726839edq.80.1585657976533;
 Tue, 31 Mar 2020 05:32:56 -0700 (PDT)
MIME-Version: 1.0
From:   Vaidas BoQsc <vaidas.boqsc@gmail.com>
Date:   Tue, 31 Mar 2020 15:32:19 +0300
Message-ID: <CAB+qc9C1Pi6MxFGwph8TGHPbm92iyibj61yMNHgXT-MccSa68A@mail.gmail.com>
Subject: Output only currently active local IP addresses
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I would like to know the correct robust way to obtain/get local IPv4
addresses of all active currently network interfaces.

I tried a command: ip --brief address
however it provides a lot of unecessary information: interface name,
status of UP/Down and lots of other additional information and
formatting, when all I need is only literal ip addresses as an output.

I couldn't find a way to get such output without using parsing tools
and piping. Is it true that ip command does not have a way to display
currently active ip addresses as a simple list without any formatting
and without inactive interfaces' information and pseudo interfaces
like ip address of localhost?
