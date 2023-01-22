Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1F1676B02
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 05:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjAVEPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 23:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAVEPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 23:15:11 -0500
Received: from a48-122.smtp-out.amazonses.com (a48-122.smtp-out.amazonses.com [54.240.48.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8BD11EA9
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 20:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zp2ap7btoiiow65hultmctjebh3tse7g; d=aaront.org; t=1674360909;
        h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type:Content-Transfer-Encoding;
        bh=El94OLBcOjrU8ENZCAHXYI4ovybWTBC+42oILjQhmS4=;
        b=SGGzHi85g1fBOLEKC5cwbpS+Lj5QsTmycrn4B30RDMUS20vk0tbdUf8FScDafJlY
        D6loIXbRkPJ7o7TAj7OuevQfVRkJDz7LHalBPP4sjYg9iFEbDsC+FlOLH++UlUH4E+/
        UfCkki1uKAq1iLn+GmqwQeCp0Jfrqkyza8XNBKmo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=6gbrjpgwjskckoa6a5zn6fwqkn67xbtw; d=amazonses.com; t=1674360909;
        h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=El94OLBcOjrU8ENZCAHXYI4ovybWTBC+42oILjQhmS4=;
        b=SrRnv4k+5+n2I5vTJkL2d7VB+fOMnVNC5xQMrQy+1RTgaNnAT6RGJNlRMoI6HZg/
        A6T+aTGqBseZ/VcYqhNyRJwH4cmdRMXAvoOHg013L+jyPnYtTcLN5vd06Dv/cpWAZnI
        fi9sj4UGunFSJZOc3PpFGyCw33cMFcnkVdyd4g8A=
MIME-Version: 1.0
Date:   Sun, 22 Jan 2023 04:15:08 +0000
From:   Aaron Thompson <dev@aaront.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: mv88e6xxx assisted learning on CPU port
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <01000185d7afea8b-cdad9c75-b82b-456e-80c1-ce62d6afe761-000000@email.amazonses.com>
X-Sender: dev@aaront.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.us-east-1.8/56jQl+KfkRukJqWjlnf+MtEL0x/NchId1fC0q616g=:AmazonSES
X-SES-Outgoing: 2023.01.22-54.240.48.122
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias, Vladimir, et al.,

Just a quick question: Is there a reason why the patch to enable 
assisted_learning_on_cpu_port for mv88e6xxx never made it to mainline? 
It was included in this RFC series:

https://lore.kernel.org/all/20210224114350.2791260-14-olteanv@gmail.com/

But not in the series that eventually made it to mainline. In my 
searching on lore, I haven't been able to find anything else about it, 
yea or nay.

Thanks,
-- Aaron
