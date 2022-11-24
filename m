Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3CC637847
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 13:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiKXMBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 07:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiKXMBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 07:01:00 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A673B9607;
        Thu, 24 Nov 2022 04:00:59 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1oyAuX-0007HF-2K; Thu, 24 Nov 2022 13:00:57 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oyAuW-000Ueg-Rz; Thu, 24 Nov 2022 13:00:56 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
Subject: FOSDEM: 2023 CFP for Kernel Devroom
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, brauner@kernel.org,
        stgraber@ubuntu.com
Message-ID: <365c4da0-202b-a96e-0476-b17cd6f9c8b6@iogearbox.net>
Date:   Thu, 24 Nov 2022 13:00:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26730/Thu Nov 24 09:18:49 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

We are pleased to announce the Call for Participation (CFP) for the FOSDEM 2023
Kernel Devroom.

FOSDEM 2023 will be over the weekend of the 4th and 5th of February in Brussels,
Belgium. FOSDEM is a free and non-commercial event organized by the community for
the community. The goal is to provide free and open source software developers and
communities a place to meet to:

* Get in touch with other developers and projects;
* Be informed about the latest developments in the free software world;
* Be informed about the latest developments in the open source world;
* Attend interesting talks and presentations on various topics by project leaders
   and committers;
* To promote the development and benefits of free software and open source solutions.
* Participation and attendance is totally free, though the organizers gratefully
   accept donations and sponsorship.

## Format

The Kernel Devroom will be running all day on Sunday, 5 February, starting at 9am
and finishing at 5pm.

We're looking for talk or demo proposals in one of the following 4 sizes:

   10 minutes (e.g., a short demo)
   20 minutes (e.g., a project update)
   30 minutes (e.g., introduction to a new technology or a deep dive on a complex feature)
   40 minutes (e.g., a deep dive on a complex feature)

In all cases, please allow for at least 5 minutes of questions (10 min preferred for
the 30 min slots). In general, shorter content will be more likely to get approved as
we want to cover a wide range of topics.

## Proposals

Proposals should be sent through the FOSDEM scheduling system at:
https://penta.fosdem.org/submission/FOSDEM23/ Note that if you submitted a proposal to
FOSDEM in the past, you can and should re-use your existing account rather than register
a new one. If you have no account yet please create a new one. Make sure to fill in your
speaker bio.

Please select the "Kernel" as the track and ensure you include the following information
when submitting a proposal:

| Section | Field	| Notes                                                                           |
| ------- | ----------- | ------------------------------------------------------------------------------- |
| Person  | Name(s)	| Your first, last and public names.                                              |
| Person  | Abstract	| A short bio.                                                                    |
| Person  | Photo	| Please provide a photo.                                                         |
| Event	  | Event Title	| This is the title of your talk - please be descriptive to encourage attendance. |
| Event	  | Abstract	| Short abstract of one or two paragraphs.                                        |
| Event	  | Duration	| Please indicate the length of your talk; 10 min, 20 min, 30, or 40 min          |

The CFP deadline is Saturday, 10 December 2022.

## Topics

The Kernel Devroom aims to cover a wide range of different topics so don't be shy. The following
list should just serve as an inspiration:

   * Filesystems and Storage
   * io_uring
   * Tracing
   * eBPF
   * Fuzzing
   * System Boot
   * Security
   * Networking
   * Namespaces and Cgroups
   * Virtualization
   * Rust in the Linux Kernel

## Code of Conduct

We'd like to remind all speakers and attendees that all of the presentations and discussions in
our devroom are held under the guidelines set in the FOSDEM Code of Conduct and we expect attendees,
speakers, and volunteers to follow the CoC at all times.

If you submit a proposal and it is accepted, you will be required to confirm that you accept the
FOSDEM CoC. If you have any questions about the CoC or wish to have one of the devroom organizers
review your presentation slides or any other content for CoC compliance, please email us and we will
do our best to assist you.

Thanks!
Christian Brauner
Stéphane Graber
Daniel Borkmann
