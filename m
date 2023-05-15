Return-Path: <netdev+bounces-2597-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE7E9702A53
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 969A02810EA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6518C2D3;
	Mon, 15 May 2023 10:16:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62D8883A
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:16:55 +0000 (UTC)
Received: from mk.mickytgi.top (unknown [43.226.152.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 347EC2D49
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:16:31 -0700 (PDT)
Received: from DESKTOP-4COHUL1 (58.60.34.112) by mk.mickytgi.top id hc837u0e97c3 for <netdev@vger.kernel.org>; Mon, 15 May 2023 18:15:30 +0800 (envelope-from <mk10@mk.mickytgi.top>)
From: "Jack Lee" <sales03@hystou.cn>
Subject: Firewall Mini PC
To: netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: mk10@mk.mickytgi.top
Reply-To: sales03@hystou.cn
Date: Mon, 15 May 2023 18:15:31 +0800
X-Priority: 3
X-MSMail-Priority: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Content-Disposition: inline
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_40,FROM_SUSPICIOUS_NTLD,
	HEADER_FROM_DIFFERENT_DOMAINS,MISSING_MID,RDNS_NONE,SPF_HELO_NONE,
	SPF_NONE,TO_NO_BRKTS_MSFT,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Message-Id: <20230515101656.B6518C2D3@smtp.subspace.kernel.org>

RGVhciBteSBmcmllbmQsDQogDQpUaGlzIGlzIEphY2sgTGVlIGZyb20gSFlTVE9VIG1pbmkgcGMg
ZmFjdG9yeSBsb2NhdGVkIGluIENoaW5hLiBXZSBIeXN0b3UgaGFzIGJlZW4gcHJvZHVjaW5nIGFu
ZCBzdXBwbHlpbmcgTWluaSBQQyBzaW5jZSAyMDE0LCB3ZSBoYXZlIHBhc3NlZCBJU085MDAxLCBh
bmQgYWxsIG91ciBwcm9kdWN0cyBoYXMgQ0UmUk9IUyBjZXJ0aWZpY2F0ZS4gDQogDQpQbGVhc2Ug
YWxsb3cgbWUgdG8gaW50cm9kdWNlIGEgcHJvZHVjdCBmaXJzdO+8mg0KIA0KQ1BVOkludGVsIENv
cmUgaTMgNzEwMEYgDQpJbnRlbCBDb3JlIGk3IDk3MDBGIA0KUkFNOiB1cCB0byA2NEdCIEREUjQg
bWVtb3J5DQpTdG9yYWdlOiAxICptU0FUQSBTU0QgLDEqMTIuNSBpbmNoIFNBVEEgU1NEL0hERCwg
bW9yZSB0aGFuIDVUQiBhdmFpbGFibGUgR3JhcGhpY3M6IE5WSURJQSBHZUZvcmNlIEdUWCAxNjUw
IDRHQiBHRERSNg0KTWluaSBQQyBkaW1lbnNpb246IDI3LjcgeCAyMC4xeDUuNiBjbQ0KIA0KV291
bGQgeW91IHdhbnQgdG8gdXNlIHRoaXMgY29tcHV0ZXIgYXQgaG9tZSBvciBpbiBvZmZpY2U/IExl
dCBtZSBrbm93IGFuZCBJIHdpbGwgaGVscCB5b3UgZmluZCB0aGUgcmlnaHQgc29sdXRpb24uDQog
DQpZb3VyIGZhaXRoZnVsbHksDQogDQpKY2FrIExlZQ0KU2FsZXMgQXNzaXN0YW50ICBJbCAgSHlz
dG91IFRlY2hub2xvZ3kgQ28uLCBMaW1pdGVkDQpUZWwvV2hhdHNBcHAgOiAoKzg2KSAxMzMtMTY1
NDY1MzcNCkUtbWFpbDogc2FsZXMyMUBoeXN0b3UuY29tDQpXZWI6IHd3dy5oeXN0b3UuY29tIA0K
U3VwcGx5IE1pbmkgUEMgLSBBSU8gRGVza3RvcCBQQyAtIEluZHVzdHJpYWwgQ29tcHV0ZXINCg==

